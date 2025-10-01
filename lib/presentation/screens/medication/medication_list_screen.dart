import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/medication_model.dart';
import '../../providers/medication_provider.dart';
import '../../widgets/common/accessible_button.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/medication/medication_card.dart';
import '../../widgets/common/skeleton_loader.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicationProvider>().loadTodayMedications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: Text(
          '약 복용 관리',
          style: TossTextStyle.header1.copyWith(
            color: TossColors.grey900,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: TossColors.grey700),
            onPressed: () => _showCalendarBottomSheet(),
            tooltip: '날짜 선택',
          ),
        ],
      ),
      body: Consumer<MedicationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.medications.isEmpty) {
            return _buildLoadingSkeleton();
          }

          if (provider.error != null && provider.medications.isEmpty) {
            return AppErrorWidget(
              error: provider.error!,
              onRetry: () => provider.loadTodayMedications(),
            );
          }

          return LoadingOverlay(
            isLoading: provider.isLoading,
            child: RefreshIndicator(
              onRefresh: () => provider.loadTodayMedications(),
              color: TossColors.blue500,
              child: Column(
                children: [
                  _buildSummaryCard(provider),
                  Expanded(
                    child: _buildMedicationList(provider.medications),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(MedicationProvider provider) {
    final totalCount = provider.medications.length;
    final takenCount = provider.medications.where((med) => med.isTaken).length;
    final completionRate = totalCount > 0 ? (takenCount / totalCount * 100) : 0;

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: TossColors.grey200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '오늘의 복용 현황',
                style: TossTextStyle.header2.copyWith(
                  color: TossColors.grey900,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: takenCount == totalCount ? TossColors.green100 : TossColors.blue100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '$takenCount/$totalCount 완료',
                  style: TossTextStyle.body2.copyWith(
                    color: takenCount == totalCount ? TossColors.green600 : TossColors.blue600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          LinearProgressIndicator(
            value: completionRate / 100,
            backgroundColor: TossColors.grey200,
            color: takenCount == totalCount ? TossColors.green500 : TossColors.blue500,
            minHeight: 8.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 8.h),
          Text(
            '${completionRate.toStringAsFixed(0)}% 완료',
            style: TossTextStyle.caption.copyWith(
              color: TossColors.grey600,
            ),
          ),
          if (takenCount == totalCount) ...[
            SizedBox(height: 8.h),
            Text(
              '🎉 오늘 모든 약을 복용했어요!',
              style: TossTextStyle.body2.copyWith(
                color: TossColors.green600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildMedicationList(List<MedicationModel> medications) {
    if (medications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: medications.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final medication = medications[index];
        return MedicationCard(
          medication: medication,
          onTap: () => _showMedicationDetail(medication),
          onToggleTaken: (taken) => _toggleMedication(medication.id, taken),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medication_outlined,
            size: 80.w,
            color: TossColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            '오늘 복용할 약이 없어요',
            style: TossTextStyle.header2.copyWith(
              color: TossColors.grey600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '약 복용 일정이 추가되면\n여기에 표시됩니다',
            style: TossTextStyle.body1.copyWith(
              color: TossColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: [
        // 요약 카드 스켈레톤
        Container(
          margin: EdgeInsets.all(16.w),
          child: SkeletonLoader(
            child: Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ),
        // 리스트 아이템 스켈레톤
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 5,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return SkeletonLoader(
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showCalendarBottomSheet() async {
    final selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        height: 400.h,
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: TossColors.grey300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              '날짜 선택',
              style: TossTextStyle.header2.copyWith(
                color: TossColors.grey900,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                onDateChanged: (date) => Navigator.pop(context, date),
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedDate != null) {
      context.read<MedicationProvider>().loadMedicationsByDate(selectedDate);
    }
  }

  void _showMedicationDetail(MedicationModel medication) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TossColors.grey300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              medication.name,
              style: TossTextStyle.header1.copyWith(
                color: TossColors.grey900,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              medication.description,
              style: TossTextStyle.body1.copyWith(
                color: TossColors.grey600,
              ),
            ),
            SizedBox(height: 20.h),
            _buildDetailRow('용량', medication.dosage),
            _buildDetailRow('복용 시간', medication.times.join(', ')),
            _buildDetailRow('복용 빈도', medication.frequency),
            if (medication.notes?.isNotEmpty == true)
              _buildDetailRow('참고사항', medication.notes!),
            SizedBox(height: 30.h),
            AccessibleButton(
              label: '닫기',
              onPressed: () => Navigator.pop(context),
              backgroundColor: TossColors.grey100,
              textColor: TossColors.grey700,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TossTextStyle.body2.copyWith(
                color: TossColors.grey500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              value,
              style: TossTextStyle.body1.copyWith(
                color: TossColors.grey800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleMedication(int medicationId, bool taken) {
    context.read<MedicationProvider>().toggleMedication(medicationId, taken);
  }
}
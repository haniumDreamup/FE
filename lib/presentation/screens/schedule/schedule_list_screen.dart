import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/schedule_model.dart';
import '../../providers/schedule_provider.dart';
import '../../widgets/common/accessible_button.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/schedule/schedule_card.dart';
import '../../widgets/common/skeleton_loader.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleProvider>().loadTodaySchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: Text(
          '일정 관리',
          style: TossTextStyle.header1.copyWith(
            color: TossColors.grey900,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_view_week, color: TossColors.grey700),
            onPressed: () => _showWeekView(),
            tooltip: '주간 보기',
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, color: TossColors.grey700),
            onPressed: () => _showCalendarBottomSheet(),
            tooltip: '날짜 선택',
          ),
        ],
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.schedules.isEmpty) {
            return _buildLoadingSkeleton();
          }

          if (provider.error != null && provider.schedules.isEmpty) {
            return AppErrorWidget(
              error: provider.error!,
              onRetry: () => provider.loadTodaySchedules(),
            );
          }

          return LoadingOverlay(
            isLoading: provider.isLoading,
            child: RefreshIndicator(
              onRefresh: () => provider.loadTodaySchedules(),
              color: TossColors.blue500,
              child: Column(
                children: [
                  _buildSummaryCard(provider),
                  Expanded(
                    child: _buildScheduleList(provider.schedules),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(ScheduleProvider provider) {
    final totalCount = provider.schedules.length;
    final completedCount = provider.schedules.where((schedule) => schedule.isCompleted).length;
    final completionRate = totalCount > 0 ? (completedCount / totalCount * 100) : 0;
    final overdueCount = provider.schedules.where((schedule) => schedule.isOverdue).length;

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
                '오늘의 일정 현황',
                style: TossTextStyle.header2.copyWith(
                  color: TossColors.grey900,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: completedCount == totalCount ? TossColors.green100 : TossColors.blue100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '$completedCount/$totalCount 완료',
                  style: TossTextStyle.body2.copyWith(
                    color: completedCount == totalCount ? TossColors.green600 : TossColors.blue600,
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
            color: completedCount == totalCount ? TossColors.green500 : TossColors.blue500,
            minHeight: 8.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${completionRate.toStringAsFixed(0)}% 완료',
                style: TossTextStyle.caption.copyWith(
                  color: TossColors.grey600,
                ),
              ),
              if (overdueCount > 0)
                Text(
                  '지연된 일정 ${overdueCount}개',
                  style: TossTextStyle.caption.copyWith(
                    color: TossColors.red600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          if (completedCount == totalCount) ...[
            SizedBox(height: 8.h),
            Text(
              '🎉 오늘 모든 일정을 완료했어요!',
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

  Widget _buildScheduleList(List<ScheduleModel> schedules) {
    if (schedules.isEmpty) {
      return _buildEmptyState();
    }

    // 시간대별로 일정 그룹화
    final groupedSchedules = _groupSchedulesByTime(schedules);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: groupedSchedules.length,
      itemBuilder: (context, index) {
        final timeSlot = groupedSchedules.keys.elementAt(index);
        final timeSchedules = groupedSchedules[timeSlot]!;
        
        return _buildTimeSection(timeSlot, timeSchedules);
      },
    );
  }

  Widget _buildTimeSection(String timeSlot, List<ScheduleModel> schedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h, top: 16.h),
          child: Text(
            timeSlot,
            style: TossTextStyle.header3.copyWith(
              color: TossColors.grey800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...schedules.map((schedule) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: ScheduleCard(
            schedule: schedule,
            onTap: () => _showScheduleDetail(schedule),
            onToggleComplete: (completed) => _toggleSchedule(schedule.id, completed),
          ),
        )),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 80.w,
            color: TossColors.grey400,
          ),
          SizedBox(height: 16.h),
          Text(
            '오늘 예정된 일정이 없어요',
            style: TossTextStyle.header2.copyWith(
              color: TossColors.grey600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '새로운 일정이 추가되면\n여기에 표시됩니다',
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

  Map<String, List<ScheduleModel>> _groupSchedulesByTime(List<ScheduleModel> schedules) {
    final Map<String, List<ScheduleModel>> grouped = {};
    
    for (final schedule in schedules) {
      final hour = schedule.scheduledTime.hour;
      String timeSlot;
      
      if (hour >= 6 && hour < 12) {
        timeSlot = '오전 (06:00 - 12:00)';
      } else if (hour >= 12 && hour < 18) {
        timeSlot = '오후 (12:00 - 18:00)';
      } else if (hour >= 18 && hour < 22) {
        timeSlot = '저녁 (18:00 - 22:00)';
      } else {
        timeSlot = '밤 (22:00 - 06:00)';
      }
      
      if (!grouped.containsKey(timeSlot)) {
        grouped[timeSlot] = [];
      }
      grouped[timeSlot]!.add(schedule);
    }
    
    // 시간 순으로 정렬
    for (final timeSlot in grouped.keys) {
      grouped[timeSlot]!.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    }
    
    return grouped;
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
      context.read<ScheduleProvider>().loadSchedulesByDate(selectedDate);
    }
  }

  Future<void> _showWeekView() async {
    context.read<ScheduleProvider>().loadWeekSummary();
    // 주간 보기 화면으로 이동하는 로직 추가
  }

  void _showScheduleDetail(ScheduleModel schedule) {
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
            Row(
              children: [
                Text(
                  schedule.title,
                  style: TossTextStyle.header1.copyWith(
                    color: TossColors.grey900,
                  ),
                ),
                const Spacer(),
                if (schedule.isCompleted)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: TossColors.green100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '완료',
                      style: TossTextStyle.caption.copyWith(
                        color: TossColors.green600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              schedule.description,
              style: TossTextStyle.body1.copyWith(
                color: TossColors.grey600,
              ),
            ),
            SizedBox(height: 20.h),
            _buildDetailRow('시간', schedule.timeString),
            _buildDetailRow('카테고리', schedule.category),
            _buildDetailRow('우선순위', _getPriorityText(schedule.priority)),
            if (schedule.notes?.isNotEmpty == true)
              _buildDetailRow('참고사항', schedule.notes!),
            if (schedule.tags?.isNotEmpty == true)
              _buildDetailRow('태그', schedule.tags!.join(', ')),
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

  String _getPriorityText(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return '높음';
      case 'medium':
        return '보통';
      case 'low':
        return '낮음';
      default:
        return priority;
    }
  }

  void _toggleSchedule(int scheduleId, bool completed) {
    context.read<ScheduleProvider>().toggleSchedule(scheduleId, completed);
  }
}
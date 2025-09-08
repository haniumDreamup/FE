import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/medication_model.dart';

class MedicationCard extends StatelessWidget {
  final MedicationModel medication;
  final VoidCallback? onTap;
  final Function(bool)? onToggleTaken;

  const MedicationCard({
    super.key,
    required this.medication,
    this.onTap,
    this.onToggleTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: medication.isTaken ? TossColors.grey100 : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: medication.isTaken ? TossColors.grey300 : TossColors.grey200,
          width: 1,
        ),
        boxShadow: medication.isTaken ? null : [
          BoxShadow(
            color: TossColors.grey200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                _buildMedicationIcon(),
                SizedBox(width: 16.w),
                Expanded(child: _buildMedicationInfo()),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationIcon() {
    final color = _getMedicationColor();
    
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: medication.isTaken 
            ? TossColors.grey200 
            : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        _getMedicationIcon(),
        color: medication.isTaken ? TossColors.grey500 : color,
        size: 24.w,
      ),
    );
  }

  Widget _buildMedicationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                medication.name,
                style: TossTextStyle.header3.copyWith(
                  color: medication.isTaken ? TossColors.grey500 : TossColors.grey900,
                  decoration: medication.isTaken ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (medication.isImportant && !medication.isTaken) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: TossColors.red100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '중요',
                  style: TossTextStyle.caption.copyWith(
                    color: TossColors.red600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          medication.description,
          style: TossTextStyle.body2.copyWith(
            color: medication.isTaken ? TossColors.grey400 : TossColors.grey600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildInfoChip(medication.dosage, Icons.medication),
            SizedBox(width: 8.w),
            _buildInfoChip(medication.times.join(', '), Icons.schedule),
          ],
        ),
        if (medication.isTaken && medication.takenAt != null) ...[
          SizedBox(height: 8.h),
          Text(
            '${_formatTime(medication.takenAt!)} 복용 완료',
            style: TossTextStyle.caption.copyWith(
              color: TossColors.green600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: medication.isTaken ? TossColors.grey200 : TossColors.blue50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.w,
            color: medication.isTaken ? TossColors.grey500 : TossColors.blue600,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TossTextStyle.caption.copyWith(
              color: medication.isTaken ? TossColors.grey500 : TossColors.blue600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (medication.isTaken) {
      return Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: TossColors.green100,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Icon(
          Icons.check,
          color: TossColors.green600,
          size: 20.w,
        ),
      );
    }

    return GestureDetector(
      onTap: () => onToggleTaken?.call(true),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: TossColors.blue500,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 20.w,
        ),
      ),
    );
  }

  Color _getMedicationColor() {
    switch (medication.color.toLowerCase()) {
      case 'red':
        return TossColors.red500;
      case 'blue':
        return TossColors.blue500;
      case 'green':
        return TossColors.green500;
      case 'yellow':
        return TossColors.yellow500;
      case 'purple':
        return const Color(0xFF8B5CF6);
      case 'orange':
        return const Color(0xFFF97316);
      default:
        return TossColors.blue500;
    }
  }

  IconData _getMedicationIcon() {
    switch (medication.shape.toLowerCase()) {
      case 'tablet':
        return Icons.medication;
      case 'capsule':
        return Icons.medication_liquid;
      case 'syrup':
        return Icons.local_drink;
      case 'injection':
        return Icons.colorize;
      case 'patch':
        return Icons.healing;
      default:
        return Icons.medication;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
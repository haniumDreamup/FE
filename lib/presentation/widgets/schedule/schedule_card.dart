import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/schedule_model.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;
  final VoidCallback? onTap;
  final Function(bool)? onToggleComplete;

  const ScheduleCard({
    super.key,
    required this.schedule,
    this.onTap,
    this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: schedule.isCompleted ? TossColors.grey100 : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _getBorderColor(),
          width: schedule.isOverdue && !schedule.isCompleted ? 2 : 1,
        ),
        boxShadow: schedule.isCompleted ? null : [
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
                _buildScheduleIcon(),
                SizedBox(width: 16.w),
                Expanded(child: _buildScheduleInfo()),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleIcon() {
    final color = _getScheduleColor();
    
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: schedule.isCompleted 
            ? TossColors.grey200 
            : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        _getScheduleIcon(),
        color: schedule.isCompleted ? TossColors.grey500 : color,
        size: 24.w,
      ),
    );
  }

  Widget _buildScheduleInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                schedule.title,
                style: TossTextStyle.header3.copyWith(
                  color: schedule.isCompleted ? TossColors.grey500 : TossColors.grey900,
                  decoration: schedule.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            _buildPriorityBadge(),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          schedule.description,
          style: TossTextStyle.body2.copyWith(
            color: schedule.isCompleted ? TossColors.grey400 : TossColors.grey600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            _buildInfoChip(schedule.timeString, Icons.access_time),
            SizedBox(width: 8.w),
            _buildInfoChip(schedule.category, Icons.category_outlined),
          ],
        ),
        if (schedule.isOverdue && !schedule.isCompleted) ...[
          SizedBox(height: 8.h),
          Text(
            '⚠️ 예정 시간이 지났어요',
            style: TossTextStyle.caption.copyWith(
              color: TossColors.red600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (schedule.isCompleted && schedule.completedAt != null) ...[
          SizedBox(height: 8.h),
          Text(
            '${_formatTime(schedule.completedAt!)} 완료',
            style: TossTextStyle.caption.copyWith(
              color: TossColors.green600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriorityBadge() {
    if (schedule.priority.toLowerCase() != 'high' || schedule.isCompleted) {
      return const SizedBox.shrink();
    }

    return Container(
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
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: schedule.isCompleted ? TossColors.grey200 : TossColors.blue50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.w,
            color: schedule.isCompleted ? TossColors.grey500 : TossColors.blue600,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TossTextStyle.caption.copyWith(
              color: schedule.isCompleted ? TossColors.grey500 : TossColors.blue600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (schedule.isCompleted) {
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
      onTap: () => onToggleComplete?.call(true),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: schedule.isOverdue ? TossColors.red500 : TossColors.blue500,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 20.w,
        ),
      ),
    );
  }

  Color _getBorderColor() {
    if (schedule.isCompleted) {
      return TossColors.grey300;
    }
    if (schedule.isOverdue) {
      return TossColors.red500;
    }
    return TossColors.grey200;
  }

  Color _getScheduleColor() {
    switch (schedule.color.toLowerCase()) {
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

  IconData _getScheduleIcon() {
    switch (schedule.icon.toLowerCase()) {
      case 'work':
        return Icons.work_outline;
      case 'health':
        return Icons.local_hospital_outlined;
      case 'education':
        return Icons.school_outlined;
      case 'shopping':
        return Icons.shopping_cart_outlined;
      case 'meeting':
        return Icons.groups_outlined;
      case 'exercise':
        return Icons.fitness_center_outlined;
      case 'meal':
        return Icons.restaurant_outlined;
      case 'appointment':
        return Icons.event_outlined;
      case 'entertainment':
        return Icons.movie_outlined;
      case 'travel':
        return Icons.flight_outlined;
      default:
        return Icons.event_outlined;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/emergency_model.dart';

class EmergencyButton extends StatelessWidget {
  final EmergencyType emergencyType;
  final VoidCallback? onPressed;

  const EmergencyButton({
    super.key,
    required this.emergencyType,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emergencyType.emoji,
                  style: TextStyle(fontSize: 32.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  emergencyType.displayName,
                  style: TossTextStyle.body1.copyWith(
                    color: _getTextColor(),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (emergencyType) {
      case EmergencyType.medical:
        return TossColors.red50;
      case EmergencyType.lost:
        return TossColors.blue50;
      case EmergencyType.panicButton:
      case EmergencyType.manualAlert:
        return const Color(0xFFF3E8FF); // Purple 50
      default:
        return TossColors.grey50;
    }
  }

  Color _getBorderColor() {
    switch (emergencyType) {
      case EmergencyType.medical:
        return TossColors.red500;
      case EmergencyType.lost:
        return TossColors.blue500;
      case EmergencyType.panicButton:
      case EmergencyType.manualAlert:
        return const Color(0xFF8B5CF6); // Purple 500
      default:
        return TossColors.grey500;
    }
  }

  Color _getTextColor() {
    switch (emergencyType) {
      case EmergencyType.medical:
        return TossColors.red700;
      case EmergencyType.lost:
        return TossColors.blue700;
      case EmergencyType.panicButton:
      case EmergencyType.manualAlert:
        return const Color(0xFF6B21A8); // Purple 700
      default:
        return TossColors.grey700;
    }
  }
}
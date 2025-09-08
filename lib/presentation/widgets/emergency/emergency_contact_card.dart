import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/emergency_model.dart';

class EmergencyContactCard extends StatelessWidget {
  final EmergencyContactModel contact;
  final VoidCallback? onTap;

  const EmergencyContactCard({
    super.key,
    required this.contact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: contact.isActive ? Colors.white : TossColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: contact.isPrimary ? TossColors.blue500 : TossColors.grey200,
          width: contact.isPrimary ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: contact.isActive ? onTap : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                _buildAvatar(),
                SizedBox(width: 16.w),
                Expanded(child: _buildContactInfo()),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: contact.isActive ? TossColors.blue100 : TossColors.grey200,
        borderRadius: BorderRadius.circular(24.w),
      ),
      child: Icon(
        _getRelationshipIcon(),
        color: contact.isActive ? TossColors.blue600 : TossColors.grey500,
        size: 24.w,
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                contact.displayName,
                style: TossTextStyle.header3.copyWith(
                  color: contact.isActive ? TossColors.grey900 : TossColors.grey500,
                ),
              ),
            ),
            if (contact.isPrimary) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: TossColors.blue100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '주',
                  style: TossTextStyle.caption.copyWith(
                    color: TossColors.blue600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          contact.relationshipDisplay,
          style: TossTextStyle.body2.copyWith(
            color: contact.isActive ? TossColors.grey600 : TossColors.grey400,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          contact.phoneNumber,
          style: TossTextStyle.body2.copyWith(
            color: contact.isActive ? TossColors.grey700 : TossColors.grey400,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (contact.notes?.isNotEmpty == true) ...[
          SizedBox(height: 4.h),
          Text(
            contact.notes!,
            style: TossTextStyle.caption.copyWith(
              color: contact.isActive ? TossColors.grey500 : TossColors.grey400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton() {
    if (!contact.isActive) {
      return Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: TossColors.grey200,
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Icon(
          Icons.phone_disabled,
          color: TossColors.grey500,
          size: 16.w,
        ),
      );
    }

    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: TossColors.green100,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Icon(
        Icons.call,
        color: TossColors.green600,
        size: 16.w,
      ),
    );
  }

  IconData _getRelationshipIcon() {
    switch (contact.relationship.toLowerCase()) {
      case 'parent':
        return Icons.family_restroom;
      case 'sibling':
        return Icons.people_outline;
      case 'guardian':
        return Icons.shield_outlined;
      case 'caregiver':
        return Icons.favorite_outline;
      case 'friend':
        return Icons.person_outline;
      case 'doctor':
        return Icons.medical_services_outlined;
      case 'nurse':
        return Icons.local_hospital_outlined;
      default:
        return Icons.contact_phone_outlined;
    }
  }
}
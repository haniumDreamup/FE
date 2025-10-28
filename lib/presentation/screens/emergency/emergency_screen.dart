import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/emergency_model.dart';
import '../../providers/emergency_provider.dart';
import '../../widgets/common/accessible_button.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/emergency/emergency_contact_card.dart';
import '../../widgets/emergency/emergency_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmergencyProvider>().loadEmergencyContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: Text(
          '긴급상황',
          style: TossTextStyle.header1.copyWith(
            color: TossColors.grey900,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Consumer<EmergencyProvider>(
        builder: (context, provider, child) {
          return LoadingOverlay(
            isLoading: provider.isLoading,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEmergencyButtons(),
                  SizedBox(height: 32.h),
                  _buildQuickActions(provider),
                  SizedBox(height: 32.h),
                  _buildEmergencyContacts(provider),
                  SizedBox(height: 32.h),
                  _buildSafetyTips(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildEmergencyButtons() {
    return Container(
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
            children: [
              Icon(
                Icons.warning_rounded,
                color: TossColors.red500,
                size: 24.w,
              ),
              SizedBox(width: 8.w),
              Text(
                '긴급상황 신고',
                style: TossTextStyle.header2.copyWith(
                  color: TossColors.grey900,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            '위험하거나 도움이 필요한 상황에서\n아래 버튼을 눌러 도움을 요청하세요',
            style: TossTextStyle.body1.copyWith(
              color: TossColors.grey600,
            ),
          ),
          SizedBox(height: 20.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1.2,
            children: [
              // 사용자가 수동으로 누를 수 있는 긴급 버튼만 표시
              EmergencyType.panicButton,
              EmergencyType.medical,
              EmergencyType.lost,
              EmergencyType.manualAlert,
            ].map((type) {
              return EmergencyButton(
                emergencyType: type,
                onPressed: () => _showEmergencyDialog(type),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(EmergencyProvider provider) {
    return Container(
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
          Text(
            '빠른 작업',
            style: TossTextStyle.header2.copyWith(
              color: TossColors.grey900,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AccessibleButton(
                  label: '안전 알림 전송',
                  onPressed: () => _sendSafetyCheck(provider),
                  backgroundColor: TossColors.green100,
                  textColor: TossColors.green700,
                  icon: Icons.check_circle_outline,
                  height: 56.h,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AccessibleButton(
                  label: '위치 공유',
                  onPressed: () => _shareLocation(provider),
                  backgroundColor: TossColors.blue100,
                  textColor: TossColors.blue700,
                  icon: Icons.location_on_outlined,
                  height: 56.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts(EmergencyProvider provider) {
    return Container(
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
                '긴급 연락처',
                style: TossTextStyle.header2.copyWith(
                  color: TossColors.grey900,
                ),
              ),
              Text(
                '${provider.emergencyContacts.length}개',
                style: TossTextStyle.body2.copyWith(
                  color: TossColors.grey500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (provider.emergencyContacts.isEmpty) ...[
            _buildEmptyContacts(),
          ] else ...[
            ...provider.emergencyContacts.take(3).map((contact) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: EmergencyContactCard(
                  contact: contact,
                  onTap: () => _callContact(contact),
                ),
              );
            }),
            if (provider.emergencyContacts.length > 3) ...[
              AccessibleButton(
                label: '모든 연락처 보기',
                onPressed: () => _showAllContacts(provider.emergencyContacts),
                backgroundColor: TossColors.grey100,
                textColor: TossColors.grey700,
                width: double.infinity,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyContacts() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: TossColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: TossColors.grey200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.contact_phone_outlined,
            size: 48.w,
            color: TossColors.grey400,
          ),
          SizedBox(height: 12.h),
          Text(
            '등록된 긴급 연락처가 없습니다',
            style: TossTextStyle.body1.copyWith(
              color: TossColors.grey600,
            ),
          ),
          SizedBox(height: 16.h),
          AccessibleButton(
            label: '연락처 추가하기',
            onPressed: () => _showAddContactDialog(),
            backgroundColor: TossColors.blue500,
            textColor: Colors.white,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTips() {
    final tips = [
      '위험한 상황에서는 주저하지 말고 도움을 요청하세요',
      '응급상황 시 정확한 위치를 알려주세요',
      '의식을 잃을 수 있는 상황이라면 미리 의료 정보를 준비해두세요',
      '정기적으로 긴급 연락처를 확인하고 업데이트하세요',
    ];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: TossColors.blue50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: TossColors.blue200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outlined,
                color: TossColors.blue600,
                size: 24.w,
              ),
              SizedBox(width: 8.w),
              Text(
                '안전 수칙',
                style: TossTextStyle.header2.copyWith(
                  color: TossColors.blue800,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...tips.map((tip) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  margin: EdgeInsets.only(top: 8.h, right: 12.w),
                  decoration: BoxDecoration(
                    color: TossColors.blue600,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    tip,
                    style: TossTextStyle.body1.copyWith(
                      color: TossColors.blue800,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _showEmergencyDialog(EmergencyType type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: TossColors.red50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  type.emoji,
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                type.displayName,
                style: TossTextStyle.header2.copyWith(
                  color: TossColors.grey900,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 경고 메시지
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: TossColors.red50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: TossColors.red200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: TossColors.red600,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '정말로 도움을 요청하시겠습니까?',
                      style: TossTextStyle.body1.copyWith(
                        color: TossColors.red800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '다음 작업이 실행됩니다:',
              style: TossTextStyle.body1.copyWith(
                color: TossColors.grey700,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _buildDialogItem('등록된 보호자에게 알림 전송', Icons.notifications_active),
            _buildDialogItem('현재 위치 공유', Icons.location_on),
            _buildDialogItem('필요시 응급 기관 연락', Icons.phone),
            SizedBox(height: 12.h),
            Text(
              '실수로 누르신 경우 취소 버튼을 눌러주세요.',
              style: TossTextStyle.body2.copyWith(
                color: TossColors.grey500,
              ),
            ),
          ],
        ),
        actions: [
          // 취소 버튼 강조
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: TossColors.grey300, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
            ),
            child: Text(
              '취소',
              style: TossTextStyle.body1.copyWith(
                color: TossColors.grey700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleEmergencyCall(type);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.red500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
              elevation: 0,
            ),
            child: Text(
              '도움 요청',
              style: TossTextStyle.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        actionsPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      ),
    );
  }

  Widget _buildDialogItem(String text, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.w,
            color: TossColors.grey600,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TossTextStyle.body2.copyWith(
                color: TossColors.grey700,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _handleEmergencyCall(EmergencyType type) {
    final provider = context.read<EmergencyProvider>();

    final request = EmergencyCallRequest(
      type: type.code,
      description: '${type.displayName} 상황으로 도움이 필요합니다.',
    );

    provider.handleEmergencyCall(request);

    // 성공 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '도움을 요청했습니다. 공 연락이 갈 예정입니다.',
          style: TossTextStyle.body1.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: TossColors.green500,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  void _sendSafetyCheck(EmergencyProvider provider) {
    provider.sendSafetyCheck();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '보호자에게 안전 알림을 전송했습니다.',
          style: TossTextStyle.body1.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: TossColors.green500,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Future<void> _shareLocation(EmergencyProvider provider) async {
    try {
      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('위치 권한이 거부되었습니다.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.');
      }

      // 실제 GPS 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 위치 공유
      await provider.shareLocation(position.latitude, position.longitude);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '현재 위치를 보호자와 공유했습니다.',
              style: TossTextStyle.body1.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: TossColors.blue500,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '위치 공유 실패: ${e.toString()}',
              style: TossTextStyle.body1.copyWith(
                color: Colors.white,
              ),
            ),
            backgroundColor: TossColors.red500,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
    }
  }

  void _callContact(EmergencyContactModel contact) {
    // 전화 걸기 기능 (실제 구현에서는 url_launcher 패키지 사용)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          '연락하기',
          style: TossTextStyle.header2.copyWith(
            color: TossColors.grey900,
          ),
        ),
        content: Text(
          '${contact.name}님에게 전화를 걸까요?',
          style: TossTextStyle.body1.copyWith(
            color: TossColors.grey700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: TossTextStyle.body1.copyWith(
                color: TossColors.grey600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _makePhoneCall(contact.phoneNumber);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.green500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              '전화하기',
              style: TossTextStyle.body1.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllContacts(List<EmergencyContactModel> contacts) {
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
              '모든 긴급 연락처',
              style: TossTextStyle.header2.copyWith(
                color: TossColors.grey900,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.separated(
                itemCount: contacts.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return EmergencyContactCard(
                    contact: contacts[index],
                    onTap: () => _callContact(contacts[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog() {
    // 연락처 추가 화면으로 이동
    Navigator.of(context).pushNamed('/emergency/contacts/add').then((result) {
      // 연락처 추가 후 돌아오면 목록 새로고침
      if (result == true) {
        context.read<EmergencyProvider>().loadEmergencyContacts();
      }
    });
  }
  
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}
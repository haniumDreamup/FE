import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/services/medication_reminder_service.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';

class MedicationReminderSettingsScreen extends StatefulWidget {
  const MedicationReminderSettingsScreen({super.key});

  @override
  State<MedicationReminderSettingsScreen> createState() => 
      _MedicationReminderSettingsScreenState();
}

class _MedicationReminderSettingsScreenState 
    extends State<MedicationReminderSettingsScreen> {
  final MedicationReminderService _reminderService = MedicationReminderService();
  late Map<String, dynamic> _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _settings = _reminderService.getSettings();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('약물 알림 설정'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '약물 알림 설정',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TossTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainSwitch(),
            if (_settings['enabled']) ...[
              SizedBox(height: 24.h),
              _buildAdvanceTimeCard(),
              SizedBox(height: 16.h),
              _buildPersistentReminderCard(),
              if (_settings['persistent']) ...[
                SizedBox(height: 16.h),
                _buildSnoozeTimeCard(),
              ],
              SizedBox(height: 24.h),
              _buildTestButton(),
            ],
            SizedBox(height: 32.h),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainSwitch() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: _settings['enabled'] 
                ? TossTheme.primaryColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.notifications_active,
            size: 32.sp,
            color: _settings['enabled'] 
                ? TossTheme.primaryColor 
                : Colors.grey,
          ),
        ),
        title: Text(
          '약물 알림',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          _settings['enabled'] 
              ? '약 복용 시간을 알려드려요' 
              : '알림이 꺼져 있어요',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Transform.scale(
          scale: 1.2,
          child: Switch(
            value: _settings['enabled'],
            onChanged: (value) async {
              await _reminderService.setRemindersEnabled(value);
              _loadSettings();
              ErrorHandler.showSuccessSnackBar(
                context,
                value ? '알림을 켰어요' : '알림을 껐어요',
              );
            },
            activeColor: TossTheme.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildAdvanceTimeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 24.sp,
                  color: TossTheme.primaryColor,
                ),
                SizedBox(width: 12.w),
                Text(
                  '미리 알림',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              '복용 ${_settings["advanceMinutes"]}분 전에 미리 알려드려요',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text(
                  '5분',
                  style: TextStyle(fontSize: 14.sp),
                ),
                Expanded(
                  child: Slider(
                    value: _settings['advanceMinutes'].toDouble(),
                    min: 5,
                    max: 60,
                    divisions: 11,
                    label: '${_settings["advanceMinutes"]}분',
                    activeColor: TossTheme.primaryColor,
                    onChanged: (value) async {
                      await _reminderService.setAdvanceMinutes(value.toInt());
                      _loadSettings();
                    },
                  ),
                ),
                Text(
                  '60분',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersistentReminderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: Icon(
          Icons.repeat,
          size: 28.sp,
          color: TossTheme.primaryColor,
        ),
        title: Text(
          '반복 알림',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '약을 드실 때까지 계속 알려드려요',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Switch(
          value: _settings['persistent'],
          onChanged: (value) async {
            await _reminderService.setPersistentReminders(value);
            _loadSettings();
          },
          activeColor: TossTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSnoozeTimeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.snooze,
                  size: 24.sp,
                  color: TossTheme.primaryColor,
                ),
                SizedBox(width: 12.w),
                Text(
                  '다시 알림 간격',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              '${_settings["snoozeMinutes"]}분마다 다시 알려드려요',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text(
                  '3분',
                  style: TextStyle(fontSize: 14.sp),
                ),
                Expanded(
                  child: Slider(
                    value: _settings['snoozeMinutes'].toDouble(),
                    min: 3,
                    max: 30,
                    divisions: 9,
                    label: '${_settings["snoozeMinutes"]}분',
                    activeColor: TossTheme.primaryColor,
                    onChanged: (value) async {
                      await _reminderService.setSnoozeMinutes(value.toInt());
                      _loadSettings();
                    },
                  ),
                ),
                Text(
                  '30분',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          await _reminderService.sendTestNotification();
          ErrorHandler.showInfoSnackBar(
            context,
            '테스트 알림을 보냈어요',
          );
        },
        icon: Icon(Icons.notifications, size: 20.sp),
        label: Text(
          '테스트 알림 보내기',
          style: TextStyle(fontSize: 16.sp),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          backgroundColor: TossTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 24.sp,
              color: Colors.blue.shade700,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '알림 설정 안내',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '• 약 복용 시간에 맞춰 자동으로 알림이 설정돼요\n'
                    '• 약을 드시면 알림이 자동으로 멈춰요\n'
                    '• 휴대폰 설정에서 알림을 허용해주세요',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.blue.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
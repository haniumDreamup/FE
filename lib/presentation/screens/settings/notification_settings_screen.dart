import 'package:flutter/material.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _isLoading = true;

  // Notification toggles
  bool _scheduleNotification = true;
  bool _medicationNotification = true;
  bool _emergencyNotification = true;
  bool _geofenceNotification = true;
  bool _guardianNotification = true;

  // Sound & Vibration
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Do Not Disturb
  bool _dndEnabled = false;
  TimeOfDay _dndStartTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _dndEndTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // TODO: 실제 API에서 알림 설정 로드
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    // TODO: 실제 API에 알림 설정 저장
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      ErrorHandler.showSuccessSnackBar(context, '알림 설정이 저장되었어요');
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _dndStartTime : _dndEndTime,
    );

    if (picked != null && mounted) {
      setState(() {
        if (isStartTime) {
          _dndStartTime = picked;
        } else {
          _dndEndTime = picked;
        }
      });
      await _saveSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('알림 설정')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notification Types Section
          _buildSectionTitle('알림 종류'),
          const SizedBox(height: 12),
          _buildNotificationToggle(
            title: '일정 알림',
            subtitle: '등록된 일정 시간에 알림',
            value: _scheduleNotification,
            onChanged: (value) async {
              setState(() {
                _scheduleNotification = value;
              });
              await _saveSettings();
            },
          ),
          const SizedBox(height: 12),
          _buildNotificationToggle(
            title: '약물 복용 알림',
            subtitle: '약 복용 시간에 알림',
            value: _medicationNotification,
            onChanged: (value) async {
              setState(() {
                _medicationNotification = value;
              });
              await _saveSettings();
            },
          ),
          const SizedBox(height: 12),
          _buildNotificationToggle(
            title: '긴급 상황 알림',
            subtitle: '낙상 감지 및 긴급 상황 알림',
            value: _emergencyNotification,
            onChanged: (value) async {
              setState(() {
                _emergencyNotification = value;
              });
              await _saveSettings();
            },
          ),
          const SizedBox(height: 12),
          _buildNotificationToggle(
            title: '안전구역 알림',
            subtitle: '안전구역 진입/이탈 알림',
            value: _geofenceNotification,
            onChanged: (value) async {
              setState(() {
                _geofenceNotification = value;
              });
              await _saveSettings();
            },
          ),
          const SizedBox(height: 12),
          _buildNotificationToggle(
            title: '보호자 알림',
            subtitle: '보호자가 보낸 메시지 알림',
            value: _guardianNotification,
            onChanged: (value) async {
              setState(() {
                _guardianNotification = value;
              });
              await _saveSettings();
            },
          ),
          const SizedBox(height: 32),

          // Sound & Vibration Section
          _buildSectionTitle('소리 및 진동'),
          const SizedBox(height: 12),
          _buildNotificationToggle(
            title: '알림 소리',
            subtitle: '알림 수신 시 소리 재생',
            value: _soundEnabled,
            onChanged: (value) async {
              setState(() {
                _soundEnabled = value;
              });
              await _saveSettings();
            },
          ),
          const SizedBox(height: 12),
          _buildNotificationToggle(
            title: '진동',
            subtitle: '알림 수신 시 진동',
            value: _vibrationEnabled,
            onChanged: (value) async {
              setState(() {
                _vibrationEnabled = value;
              });
              await _saveSettings();
            },
          ),
          const SizedBox(height: 32),

          // Do Not Disturb Section
          _buildSectionTitle('방해 금지 모드'),
          const SizedBox(height: 12),
          _buildNotificationToggle(
            title: '방해 금지 모드',
            subtitle: '지정한 시간에는 알림을 받지 않아요',
            value: _dndEnabled,
            onChanged: (value) async {
              setState(() {
                _dndEnabled = value;
              });
              await _saveSettings();
            },
          ),
          if (_dndEnabled) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '시작 시간',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dndStartTime.format(context),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _selectTime(true),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '종료 시간',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dndEndTime.format(context),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _selectTime(false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 32),

          // Test Notification Button
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {
                ErrorHandler.showInfoSnackBar(context, '테스트 알림이 전송되었어요');
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text(
                '테스트 알림 보내기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: TossTheme.tossGreen,
          ),
        ],
      ),
    );
  }
}

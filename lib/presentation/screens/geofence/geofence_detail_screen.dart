import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';

class GeofenceDetailScreen extends StatefulWidget {
  final String geofenceId;

  const GeofenceDetailScreen({
    super.key,
    required this.geofenceId,
  });

  @override
  State<GeofenceDetailScreen> createState() => _GeofenceDetailScreenState();
}

class _GeofenceDetailScreenState extends State<GeofenceDetailScreen> {
  bool _isLoading = true;
  bool _isEnabled = true;
  Map<String, dynamic>? _geofenceData;

  @override
  void initState() {
    super.initState();
    _loadGeofenceData();
  }

  Future<void> _loadGeofenceData() async {
    // TODO: 실제 API에서 안전구역 데이터 로드
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _geofenceData = {
          'name': '우리 집',
          'address': '서울시 강남구 테헤란로 123',
          'radius': '100m',
          'latitude': 37.5665,
          'longitude': 126.9780,
          'entryAlert': true,
          'exitAlert': true,
          'createdDate': '2024년 1월 1일',
        };
        _isEnabled = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleGeofence(bool value) async {
    setState(() {
      _isLoading = true;
    });

    // TODO: 실제 API 호출
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isEnabled = value;
        _isLoading = false;
      });

      ErrorHandler.showSuccessSnackBar(
        context,
        value ? '안전구역이 활성화되었어요' : '안전구역이 비활성화되었어요',
      );
    }
  }

  Future<void> _deleteGeofence() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('안전구역 삭제'),
        content: const Text('이 안전구역을 삭제하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _isLoading = true;
      });

      // TODO: 실제 API 호출
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ErrorHandler.showSuccessSnackBar(context, '안전구역이 삭제되었어요');
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _geofenceData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('안전구역 정보')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('안전구역 정보'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: 편집 화면으로 이동
              ErrorHandler.showInfoSnackBar(context, '준비 중입니다');
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteGeofence,
            tooltip: '삭제',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Map Preview (Placeholder)
            Container(
              height: 250,
              color: Colors.grey[200],
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  Positioned(
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Text(
                        '지도 미리보기 (준비 중)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Enable/Disable Switch
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isEnabled ? Icons.check_circle : Icons.cancel,
                      color: _isEnabled ? TossTheme.tossGreen : Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '안전구역 알림',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isEnabled ? '활성화됨' : '비활성화됨',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isEnabled,
                      onChanged: _toggleGeofence,
                      activeColor: TossTheme.tossGreen,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '기본 정보',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.location_on,
                    title: '구역 이름',
                    value: _geofenceData!['name'] as String,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.place,
                    title: '주소',
                    value: _geofenceData!['address'] as String,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.radio_button_checked,
                    title: '반경',
                    value: _geofenceData!['radius'] as String,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: '등록일',
                    value: _geofenceData!['createdDate'] as String,
                  ),
                  const SizedBox(height: 24),

                  // Alert Settings
                  const Text(
                    '알림 설정',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAlertToggle(
                    title: '진입 알림',
                    subtitle: '안전구역에 들어올 때 알림',
                    value: _geofenceData!['entryAlert'] as bool,
                    onChanged: (value) {
                      // TODO: 알림 설정 변경
                      ErrorHandler.showInfoSnackBar(context, '준비 중입니다');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildAlertToggle(
                    title: '이탈 알림',
                    subtitle: '안전구역을 벗어날 때 알림',
                    value: _geofenceData!['exitAlert'] as bool,
                    onChanged: (value) {
                      // TODO: 알림 설정 변경
                      ErrorHandler.showInfoSnackBar(context, '준비 중입니다');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TossTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: TossTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertToggle({
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/services/geofence_service.dart';

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
    try {
      final service = GeofenceService();
      final geofence = await service.getGeofenceDetail(int.parse(widget.geofenceId));

      if (mounted) {
        setState(() {
          _geofenceData = {
            'name': geofence.name,
            'address': geofence.description,
            'radius': '${geofence.radius.toInt()}m',
            'latitude': geofence.centerLatitude,
            'longitude': geofence.centerLongitude,
            'entryAlert': geofence.alertType.contains('ENTRY'),
            'exitAlert': geofence.alertType.contains('EXIT'),
            'createdDate': geofence.createdAt.toString().substring(0, 10),
          };
          _isEnabled = geofence.isActive;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ErrorHandler.showErrorSnackBar(context, '안전구역 정보를 불러올 수 없습니다');
      }
    }
  }

  Future<void> _toggleGeofence(bool value) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = GeofenceService();
      await service.updateGeofence(
        int.parse(widget.geofenceId),
        GeofenceUpdateRequest(
          name: _geofenceData!['name'],
          description: _geofenceData!['address'],
          isActive: value,
        ),
      );

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
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ErrorHandler.showErrorSnackBar(context, '상태 변경에 실패했습니다');
      }
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

      try {
        final service = GeofenceService();
        await service.deleteGeofence(int.parse(widget.geofenceId));

        if (mounted) {
          ErrorHandler.showSuccessSnackBar(context, '안전구역이 삭제되었어요');
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ErrorHandler.showErrorSnackBar(context, '안전구역 삭제에 실패했습니다');
        }
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
                      ErrorHandler.showInfoSnackBar(context, '준비 중입니다');
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildAlertToggle(
                    title: '이탈 알림',
                    subtitle: '안전구역을 벗어날 때 알림',
                    value: _geofenceData!['exitAlert'] as bool,
                    onChanged: (value) {
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

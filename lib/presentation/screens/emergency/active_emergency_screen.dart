import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/emergency_model.dart';
import '../../providers/emergency_provider.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';

/// 활성 긴급 상황 화면 (보호자용)
/// BIF 사용자를 위한 간단하고 명확한 UI
class ActiveEmergencyScreen extends StatefulWidget {
  const ActiveEmergencyScreen({super.key});

  @override
  State<ActiveEmergencyScreen> createState() => _ActiveEmergencyScreenState();
}

class _ActiveEmergencyScreenState extends State<ActiveEmergencyScreen> {
  bool _isLoading = false;
  List<EmergencyResponse> _activeEmergencies = [];

  @override
  void initState() {
    super.initState();
    _loadActiveEmergencies();
  }

  Future<void> _loadActiveEmergencies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<EmergencyProvider>();
      final emergencies = await provider.getActiveEmergencies();

      setState(() {
        _activeEmergencies = emergencies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getErrorMessage(e)),
            backgroundColor: TossTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          '활성 긴급 상황',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            onPressed: _loadActiveEmergencies,
            tooltip: '새로고침',
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: '긴급 상황을 확인하고 있어요...',
        child: _activeEmergencies.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                onRefresh: _loadActiveEmergencies,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _activeEmergencies.length,
                  itemBuilder: (context, index) {
                    final emergency = _activeEmergencies[index];
                    return _buildEmergencyCard(emergency);
                  },
                ),
              ),
      ),
    );
  }

  /// 빈 상태 표시
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Colors.green[400],
          ),
          const SizedBox(height: 16),
          Text(
            '활성 긴급 상황이 없어요',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '모두 안전합니다',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 긴급 상황 카드
  Widget _buildEmergencyCard(EmergencyResponse emergency) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getSeverityColor(emergency.severity),
          width: 3,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              _getSeverityColor(emergency.severity).withOpacity(0.05),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더: 사용자 이름과 긴급도
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: _getSeverityColor(emergency.severity),
                    child: Text(
                      emergency.userName[0],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emergency.userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          emergency.typeDescription,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(emergency.severity),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      emergency.severityDescription ?? '긴급',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 설명
              if (emergency.description != null &&
                  emergency.description!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          emergency.description!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // 발생 시간
              _buildInfoRow(
                Icons.access_time,
                '발생 시간',
                _formatDateTime(emergency.createdAt),
                TossTheme.infoColor,
              ),

              const SizedBox(height: 12),

              // 위치
              if (emergency.latitude != null && emergency.longitude != null)
                _buildInfoRow(
                  Icons.location_on,
                  '위치',
                  emergency.address ??
                      '${emergency.latitude}, ${emergency.longitude}',
                  Colors.red,
                ),

              const SizedBox(height: 12),

              // 상태
              _buildInfoRow(
                Icons.flag,
                '상태',
                emergency.statusDescription,
                _getStatusColor(emergency.status),
              ),

              const SizedBox(height: 16),

              // 알림 정보
              if (emergency.notificationSent)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        color: Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${emergency.responderCount ?? 0}명에게 알림 전송됨',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // 액션 버튼들
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showLocationOnMap(emergency),
                      icon: const Icon(Icons.map, size: 24),
                      label: const Text(
                        '지도 보기',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossTheme.infoColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _callUser(emergency),
                      icon: const Icon(Icons.phone, size: 24),
                      label: const Text(
                        '전화하기',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 정보 행 위젯
  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  /// 지도에 위치 표시
  void _showLocationOnMap(EmergencyResponse emergency) {
    // TODO: 지도 화면 구현 또는 외부 지도 앱 열기
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('지도 기능은 개발 중입니다'),
      ),
    );
  }

  /// 사용자에게 전화
  void _callUser(EmergencyResponse emergency) {
    // TODO: 전화 걸기 기능 구현
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${emergency.userName}에게 전화 거는 중...'),
      ),
    );
  }

  /// 심각도 색상
  Color _getSeverityColor(EmergencySeverity? severity) {
    switch (severity) {
      case EmergencySeverity.critical:
        return TossTheme.errorColor;
      case EmergencySeverity.high:
        return Colors.orange;
      case EmergencySeverity.medium:
        return TossTheme.warningColor;
      case EmergencySeverity.low:
        return TossTheme.infoColor;
      default:
        return Colors.grey;
    }
  }

  /// 상태 색상
  Color _getStatusColor(EmergencyStatus status) {
    switch (status) {
      case EmergencyStatus.resolved:
        return Colors.green;
      case EmergencyStatus.cancelled:
        return Colors.grey;
      case EmergencyStatus.responded:
        return Colors.blue;
      case EmergencyStatus.notified:
        return TossTheme.warningColor;
      case EmergencyStatus.triggered:
      case EmergencyStatus.pending:
        return TossTheme.errorColor;
    }
  }

  /// 날짜시간 포맷
  String _formatDateTime(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 1) {
        return '방금 전';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes}분 전';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}시간 전';
      } else {
        return '${dt.year}년 ${dt.month}월 ${dt.day}일 ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return dateTime;
    }
  }
}

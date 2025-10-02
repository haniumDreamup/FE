import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/emergency_model.dart';
import '../../providers/emergency_provider.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';

/// 긴급 상황 이력 화면
/// BIF 사용자를 위한 간단하고 명확한 UI
class EmergencyHistoryScreen extends StatefulWidget {
  const EmergencyHistoryScreen({super.key});

  @override
  State<EmergencyHistoryScreen> createState() => _EmergencyHistoryScreenState();
}

class _EmergencyHistoryScreenState extends State<EmergencyHistoryScreen> {
  bool _isLoading = false;
  List<SOSHistory> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final provider = context.read<EmergencyProvider>();
      final history = await provider.getSOSHistory();

      setState(() {
        _history = history;
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
          '긴급 상황 이력',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            onPressed: _loadHistory,
            tooltip: '새로고침',
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: '이력을 불러오고 있어요...',
        child: _history.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                onRefresh: _loadHistory,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    return _buildHistoryCard(item);
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
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '긴급 상황 이력이 없어요',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'SOS를 발동한 적이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// 이력 카드 위젯
  Widget _buildHistoryCard(SOSHistory item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getSeverityColor(item.severity),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _showDetailDialog(item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더: 타입과 상태
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(item.severity).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getTypeIcon(item.emergencyType),
                          size: 20,
                          color: _getSeverityColor(item.severity),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getTypeDisplay(item.emergencyType),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getSeverityColor(item.severity),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.statusDisplay,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(item.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 설명
              if (item.description != null && item.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    item.description!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // 발동 시간
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDateTime(item.triggeredAt),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              // 위치 정보
              if (item.latitude != null && item.longitude != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.address ?? '위치: ${item.latitude}, ${item.longitude}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

              // 해결됨 표시
              if (item.resolvedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '해결됨: ${_formatDateTime(item.resolvedAt!)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 상세 다이얼로그 표시
  void _showDetailDialog(SOSHistory item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getTypeIcon(item.emergencyType),
              color: _getSeverityColor(item.severity),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getTypeDisplay(item.emergencyType),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('상태', item.statusDisplay),
              _buildDetailRow('심각도', item.severityDisplay),
              _buildDetailRow('발동 시간', _formatDateTime(item.triggeredAt)),
              if (item.description != null)
                _buildDetailRow('설명', item.description!),
              if (item.address != null)
                _buildDetailRow('주소', item.address!),
              if (item.latitude != null && item.longitude != null)
                _buildDetailRow(
                  '좌표',
                  '${item.latitude}, ${item.longitude}',
                ),
              if (item.resolvedAt != null)
                _buildDetailRow('해결 시간', _formatDateTime(item.resolvedAt!)),
              if (item.resolvedBy != null)
                _buildDetailRow('해결한 사람', item.resolvedBy!),
              if (item.resolutionNotes != null)
                _buildDetailRow('해결 메모', item.resolutionNotes!),
              if (item.responseTimeSeconds != null)
                _buildDetailRow(
                  '응답 시간',
                  '${item.responseTimeSeconds}초',
                ),
              if (item.notificationSent)
                _buildDetailRow(
                  '알림 전송',
                  '${item.notificationCount ?? 0}명에게 전송됨',
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '닫기',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  /// 상세 정보 행
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// 타입 아이콘 반환
  IconData _getTypeIcon(String? type) {
    switch (type?.toUpperCase()) {
      case 'FALL_DETECTED':
      case 'FALL_DETECTION':
        return Icons.warning;
      case 'PANIC_BUTTON':
        return Icons.sos;
      case 'MANUAL_ALERT':
        return Icons.phone;
      case 'LOST':
        return Icons.location_off;
      case 'MEDICAL':
        return Icons.medical_services;
      default:
        return Icons.error_outline;
    }
  }

  /// 타입 표시명 반환
  String _getTypeDisplay(String? type) {
    switch (type?.toUpperCase()) {
      case 'FALL_DETECTED':
      case 'FALL_DETECTION':
        return '낙상 감지';
      case 'PANIC_BUTTON':
        return '긴급 버튼';
      case 'MANUAL_ALERT':
        return '수동 호출';
      case 'LOST':
        return '길 잃음';
      case 'MEDICAL':
        return '의료 긴급';
      default:
        return '기타';
    }
  }

  /// 심각도 색상 반환
  Color _getSeverityColor(String? severity) {
    switch (severity?.toUpperCase()) {
      case 'CRITICAL':
        return TossTheme.errorColor;
      case 'HIGH':
        return Colors.orange;
      case 'MEDIUM':
        return TossTheme.warningColor;
      case 'LOW':
        return TossTheme.infoColor;
      default:
        return Colors.grey;
    }
  }

  /// 상태 색상 반환
  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'RESOLVED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.grey;
      case 'RESPONDED':
        return Colors.blue;
      case 'NOTIFIED':
        return TossTheme.warningColor;
      case 'TRIGGERED':
        return TossTheme.errorColor;
      default:
        return Colors.grey;
    }
  }

  /// 날짜시간 포맷
  String _formatDateTime(String dateTime) {
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.year}년 ${dt.month}월 ${dt.day}일 ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }
}

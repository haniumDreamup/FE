import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/models/emergency_model.dart';
import '../../providers/emergency_provider.dart';

/// 낙상 감지 다이얼로그
/// 시스템에서 낙상을 감지했을 때 자동으로 표시되는 다이얼로그
/// BIF 사용자가 쉽게 이해하고 조작할 수 있도록 설계
class FallDetectionDialog extends StatefulWidget {
  final double confidence;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;

  const FallDetectionDialog({
    super.key,
    required this.confidence,
    this.latitude,
    this.longitude,
    this.imageUrl,
  });

  /// 다이얼로그 표시 (10초 카운트다운)
  static Future<void> show(
    BuildContext context, {
    required double confidence,
    double? latitude,
    double? longitude,
    String? imageUrl,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FallDetectionDialog(
        confidence: confidence,
        latitude: latitude,
        longitude: longitude,
        imageUrl: imageUrl,
      ),
    );
  }

  @override
  State<FallDetectionDialog> createState() => _FallDetectionDialogState();
}

class _FallDetectionDialogState extends State<FallDetectionDialog> {
  int _countdown = 10; // 10초 카운트다운
  Timer? _timer;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 카운트다운 시작
  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        _reportFall();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressValue = (_countdown / 10.0);

    return WillPopScope(
      onWillPop: () async => false, // 백버튼으로 닫기 방지
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 80,
              color: TossTheme.errorColor,
            ),
            const SizedBox(height: 12),
            const Text(
              '넘어지셨나요?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 카운트다운 원형 진행률
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: progressValue,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        TossTheme.errorColor,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_countdown',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: TossTheme.errorColor,
                        ),
                      ),
                      Text(
                        '초 후',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 안내 메시지
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '괜찮으시면\n아래 "괜찮아요" 버튼을\n눌러주세요',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange[900],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '버튼을 누르지 않으면\n자동으로 도움을 요청해요',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange[700],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // 괜찮아요 버튼 (크게)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _onImOkay,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '괜찮아요',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 도움 필요해요 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _isProcessing ? null : _reportFall,
              style: OutlinedButton.styleFrom(
                foregroundColor: TossTheme.errorColor,
                side: BorderSide(
                  color: TossTheme.errorColor,
                  width: 2,
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '도움 필요해요',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 괜찮다고 응답
  void _onImOkay() {
    _timer?.cancel();
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '다행이에요! 조심하세요 😊',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 낙상 신고
  Future<void> _reportFall() async {
    _timer?.cancel();

    setState(() {
      _isProcessing = true;
    });

    try {
      final request = FallDetectionRequest(
        confidence: widget.confidence,
        latitude: widget.latitude,
        longitude: widget.longitude,
        imageUrl: widget.imageUrl,
        timestamp: DateTime.now().toIso8601String(),
      );

      final provider = context.read<EmergencyProvider>();
      final response = await provider.reportFallDetection(request);

      if (mounted) {
        Navigator.of(context).pop();
        _showSuccessDialog(response);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ErrorHandler.getErrorMessage(e)),
            backgroundColor: TossTheme.errorColor,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// 성공 다이얼로그
  void _showSuccessDialog(EmergencyResponse response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 32,
            ),
            const SizedBox(width: 12),
            const Text(
              '도움 요청 완료',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '보호자에게 알림을 보냈어요',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green[900],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '곧 도움이 올 거예요.\n안전한 곳에서 기다려주세요.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[700],
                  height: 1.5,
                ),
              ),
              if (response.notificationSent) ...[
                const SizedBox(height: 12),
                Text(
                  '${response.responderCount ?? 0}명에게 알림 전송됨',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
            ),
            child: const Text(
              '확인',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

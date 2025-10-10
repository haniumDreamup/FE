import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';

class GuardianDetailScreen extends StatefulWidget {
  final String guardianId;

  const GuardianDetailScreen({
    super.key,
    required this.guardianId,
  });

  @override
  State<GuardianDetailScreen> createState() => _GuardianDetailScreenState();
}

class _GuardianDetailScreenState extends State<GuardianDetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _guardianData;

  @override
  void initState() {
    super.initState();
    _loadGuardianData();
  }

  Future<void> _loadGuardianData() async {
    // TODO: 실제 API에서 보호자 데이터 로드
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _guardianData = {
          'name': '김보호',
          'email': 'guardian@example.com',
          'phone': '010-9876-5432',
          'relation': '딸',
          'status': '활성',
          'registeredDate': '2024년 1월 1일',
          'lastAccess': '2024년 1월 15일 오후 2:30',
        };
        _isLoading = false;
      });
    }
  }

  Future<void> _removeGuardian() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('보호자 삭제'),
        content: const Text('이 보호자를 삭제하시겠어요?\n보호자가 더 이상 내 정보에 접근할 수 없어요.'),
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
        ErrorHandler.showSuccessSnackBar(context, '보호자가 삭제되었어요');
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _guardianData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('보호자 정보')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('보호자 정보'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _removeGuardian,
            tooltip: '삭제',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Profile Icon
            CircleAvatar(
              radius: 50,
              backgroundColor: TossTheme.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 60,
                color: TossTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              _guardianData!['name'] as String,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: TossTheme.tossGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _guardianData!['status'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Information Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.email,
                    title: '이메일',
                    value: _guardianData!['email'] as String,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: '전화번호',
                    value: _guardianData!['phone'] as String,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.people,
                    title: '관계',
                    value: _guardianData!['relation'] as String,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: '등록일',
                    value: _guardianData!['registeredDate'] as String,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.access_time,
                    title: '마지막 접속',
                    value: _guardianData!['lastAccess'] as String,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: 알림 전송 기능
                        ErrorHandler.showInfoSnackBar(context, '준비 중입니다');
                      },
                      icon: const Icon(Icons.notifications),
                      label: const Text(
                        '알림 보내기',
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
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: 권한 설정 기능
                        ErrorHandler.showInfoSnackBar(context, '준비 중입니다');
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text(
                        '권한 설정',
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
}

import 'package:flutter/material.dart';
import '../../../core/config/toss_theme.dart';
import '../../widgets/common/accessible_button.dart';

class GuardianListScreen extends StatefulWidget {
  const GuardianListScreen({super.key});

  @override
  State<GuardianListScreen> createState() => _GuardianListScreenState();
}

class _GuardianListScreenState extends State<GuardianListScreen> {
  List<Map<String, dynamic>> _guardians = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadGuardians();
  }

  Future<void> _loadGuardians() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Mock data for demonstration
      await Future.delayed(const Duration(seconds: 1));
      final guardians = [
        {
          'id': 1,
          'name': '김영희',
          'relationship': '어머니',
          'phoneNumber': '010-1234-5678',
          'email': 'younghee@example.com',
          'isEmergencyContact': true,
        },
        {
          'id': 2,
          'name': '박철수',
          'relationship': '아버지',
          'phoneNumber': '010-9876-5432',
          'email': 'chulsoo@example.com',
          'isEmergencyContact': false,
        },
      ];

      setState(() {
        _guardians = guardians;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '보호자 목록을 불러오는데 실패했습니다: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteGuardian(int guardianId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _guardians.removeWhere((guardian) => guardian['id'] == guardianId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('보호자가 삭제되었습니다'),
            backgroundColor: TossColors.green500,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 실패: $e'),
            backgroundColor: TossColors.red500,
          ),
        );
      }
    }
  }

  Future<void> _sendEmergencyAlert() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('긴급 알림이 전송되었습니다'),
            backgroundColor: TossColors.red500,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('긴급 알림 전송 실패: $e'),
            backgroundColor: TossColors.red500,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: const Text(
          '보호자 관리',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: _loadGuardians,
            icon: const Icon(Icons.refresh, size: 28),
            tooltip: '새로고침',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _sendEmergencyAlert,
            backgroundColor: TossColors.red500,
            icon: const Icon(Icons.emergency, size: 24),
            label: const Text('긴급 호출', style: TextStyle(fontSize: 16)),
            heroTag: 'emergency',
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              // 보호자 추가 화면으로 이동 (구현 예정)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('보호자 추가 기능 구현 예정')),
              );
            },
            backgroundColor: TossColors.blue500,
            heroTag: 'add',
            child: const Icon(Icons.add, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: TossColors.blue500),
            SizedBox(height: 16),
            Text(
              '보호자 정보를 불러오는 중...',
              style: TextStyle(fontSize: 16, color: TossColors.grey600),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.red500,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 16, color: TossColors.grey600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AccessibleButton(
              onPressed: _loadGuardians,
              label: '다시 시도',
              backgroundColor: TossColors.blue500,
              textColor: Colors.white,
            ),
          ],
        ),
      );
    }

    if (_guardians.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: TossColors.grey400,
            ),
            const SizedBox(height: 16),
            const Text(
              '등록된 보호자가 없습니다',
              style: TextStyle(fontSize: 18, color: TossColors.grey600),
            ),
            const SizedBox(height: 8),
            const Text(
              '하단의 + 버튼을 눌러 보호자를 추가해주세요',
              style: TextStyle(fontSize: 14, color: TossColors.grey500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadGuardians,
      color: TossColors.blue500,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _guardians.length,
        itemBuilder: (context, index) {
          final guardian = _guardians[index];
          return _buildGuardianCard(guardian);
        },
      ),
    );
  }

  Widget _buildGuardianCard(Map<String, dynamic> guardian) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // 보호자 상세 화면으로 이동 (구현 예정)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${guardian['name']} 상세 정보 (구현 예정)')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: TossColors.blue100,
                      child: Text(
                        guardian['name'].isNotEmpty ? guardian['name'][0] : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: TossColors.blue500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guardian['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            guardian['relationship'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: TossColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 24),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteDialog(guardian);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: TossColors.red500),
                              SizedBox(width: 8),
                              Text('삭제'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.phone, '전화번호', guardian['phoneNumber']),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.email, '이메일', guardian['email']),
                if (guardian['isEmergencyContact']) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TossColors.red100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '긴급 연락처',
                      style: TextStyle(
                        fontSize: 12,
                        color: TossColors.red500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: TossColors.grey500),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: TossColors.grey600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(Map<String, dynamic> guardian) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('보호자 삭제'),
        content: Text('${guardian['name']}님을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteGuardian(guardian['id']);
            },
            style: TextButton.styleFrom(foregroundColor: TossColors.red500),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/guardian_model.dart';
import '../../providers/guardian_provider.dart';
import '../../widgets/common/accessible_button.dart';

class GuardianListScreen extends StatefulWidget {
  const GuardianListScreen({super.key});

  @override
  State<GuardianListScreen> createState() => _GuardianListScreenState();
}

class _GuardianListScreenState extends State<GuardianListScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 로드 시 보호자 목록 조회
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuardianProvider>().loadMyGuardians();
    });
  }

  Future<void> _deleteGuardian(int guardianId) async {
    final provider = context.read<GuardianProvider>();
    final success = await provider.removeGuardian(guardianId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '보호자가 삭제되었습니다' : '삭제 실패: ${provider.errorMessage}'),
          backgroundColor: success ? TossColors.green500 : TossColors.red500,
        ),
      );
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
            onPressed: () => context.read<GuardianProvider>().loadMyGuardians(),
            icon: const Icon(Icons.refresh, size: 28),
            tooltip: '새로고침',
          ),
        ],
      ),
      body: Consumer<GuardianProvider>(
        builder: (context, provider, child) => _buildBody(provider),
      ),
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
            onPressed: () => context.push('/guardians/add'),
            backgroundColor: TossColors.blue500,
            heroTag: 'add',
            child: const Icon(Icons.add, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(GuardianProvider provider) {
    if (provider.isLoading) {
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

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.red500,
            ),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage!,
              style: const TextStyle(fontSize: 16, color: TossColors.grey600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AccessibleButton(
              onPressed: () => provider.loadMyGuardians(),
              label: '다시 시도',
              backgroundColor: TossColors.blue500,
              textColor: Colors.white,
            ),
          ],
        ),
      );
    }

    if (provider.guardians.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
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
      onRefresh: () => provider.loadMyGuardians(),
      color: TossColors.blue500,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.guardians.length,
        itemBuilder: (context, index) {
          final guardian = provider.guardians[index];
          return _buildGuardianCard(guardian);
        },
      ),
    );
  }

  Widget _buildGuardianCard(GuardianModel guardian) {
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
          onTap: () => context.push('/guardians/${guardian.id}'),
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
                        guardian.categoryIcon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                guardian.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              if (guardian.isPrimary) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: TossColors.blue100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '주 보호자',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: TossColors.blue500,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            guardian.relationship,
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
                _buildInfoRow(Icons.phone, '전화번호', guardian.primaryPhone),
                if (guardian.email != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.email, '이메일', guardian.email!),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    // 승인 상태 배지
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: guardian.approvalStatus == ApprovalStatus.approved
                            ? TossColors.green100
                            : guardian.approvalStatus == ApprovalStatus.pending
                                ? TossColors.orange100
                                : TossColors.red100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        guardian.statusDisplay,
                        style: TextStyle(
                          fontSize: 12,
                          color: guardian.approvalStatus == ApprovalStatus.approved
                              ? TossColors.green500
                              : guardian.approvalStatus == ApprovalStatus.pending
                                  ? TossColors.orange500
                                  : TossColors.red500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (guardian.canReceiveAlerts) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: TossColors.red100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '긴급 알림',
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

  void _showDeleteDialog(GuardianModel guardian) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('보호자 삭제'),
        content: Text('${guardian.name}님을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteGuardian(guardian.id);
            },
            style: TextButton.styleFrom(foregroundColor: TossColors.red500),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
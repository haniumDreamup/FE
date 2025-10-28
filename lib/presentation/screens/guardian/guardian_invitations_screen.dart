import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/guardian_model.dart';
import '../../../data/services/guardian_service.dart';
import '../../widgets/common/accessible_button.dart';

/// 받은 초대 목록 화면
class GuardianInvitationsScreen extends StatefulWidget {
  const GuardianInvitationsScreen({super.key});

  @override
  State<GuardianInvitationsScreen> createState() => _GuardianInvitationsScreenState();
}

class _GuardianInvitationsScreenState extends State<GuardianInvitationsScreen> {
  final GuardianService _guardianService = GuardianService();
  List<GuardianRelationshipModel> _invitations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInvitations();
  }

  Future<void> _loadInvitations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final invitations = await _guardianService.getMyInvitations();
      setState(() {
        _invitations = invitations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptInvitation(GuardianRelationshipModel invitation) async {
    // 초대 수락 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _buildAcceptDialog(invitation),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);

      try {
        // TODO: 실제 초대 수락 API 호출 (토큰 필요)
        // await _guardianService.acceptInvitation(invitation.invitationToken);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('초대를 수락했습니다'),
              backgroundColor: TossColors.green500,
            ),
          );
          _loadInvitations(); // 목록 새로고침
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('초대 수락 실패: ${e.toString()}'),
              backgroundColor: TossColors.red500,
            ),
          );
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _rejectInvitation(GuardianRelationshipModel invitation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('초대 거절'),
        content: Text('${invitation.userName}님의 초대를 거절하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: TossColors.red500),
            child: const Text('거절'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);

      try {
        // TODO: 실제 초대 거절 API 호출
        // await _guardianService.rejectInvitation(invitation.invitationToken);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('초대를 거절했습니다'),
              backgroundColor: TossColors.grey600,
            ),
          );
          _loadInvitations();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('초대 거절 실패: ${e.toString()}'),
              backgroundColor: TossColors.red500,
            ),
          );
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Widget _buildAcceptDialog(GuardianRelationshipModel invitation) {
    return AlertDialog(
      title: const Text(
        '초대 수락',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${invitation.userName}님의 보호자가 되시겠습니까?',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          const Text(
            '다음 권한이 부여됩니다:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildPermissionItem(Icons.location_on, '위치 확인'),
          _buildPermissionItem(Icons.emergency, '긴급 알림 수신'),
          _buildPermissionItem(Icons.calendar_today, '일정 확인'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.blue500,
            foregroundColor: Colors.white,
          ),
          child: const Text('수락하기'),
        ),
      ],
    );
  }

  Widget _buildPermissionItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: TossColors.blue500),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: const Text(
          '받은 초대',
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
            onPressed: _loadInvitations,
            icon: const Icon(Icons.refresh, size: 28),
            tooltip: '새로고침',
          ),
        ],
      ),
      body: _buildBody(),
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
              '초대 목록을 불러오는 중...',
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
            const Icon(
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
              onPressed: _loadInvitations,
              label: '다시 시도',
              backgroundColor: TossColors.blue500,
              textColor: Colors.white,
            ),
          ],
        ),
      );
    }

    if (_invitations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mail_outline,
              size: 64,
              color: TossColors.grey400,
            ),
            const SizedBox(height: 16),
            const Text(
              '받은 초대가 없습니다',
              style: TextStyle(fontSize: 18, color: TossColors.grey600),
            ),
            const SizedBox(height: 8),
            const Text(
              '다른 사용자가 보호자로 초대하면\n여기에 표시됩니다',
              style: TextStyle(fontSize: 14, color: TossColors.grey500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInvitations,
      color: TossColors.blue500,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _invitations.length,
        itemBuilder: (context, index) {
          final invitation = _invitations[index];
          return _buildInvitationCard(invitation);
        },
      ),
    );
  }

  Widget _buildInvitationCard(GuardianRelationshipModel invitation) {
    final isExpired = invitation.createdAt
        .add(const Duration(hours: 72))
        .isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isExpired ? TossColors.grey200 : TossColors.blue100,
                  child: Icon(
                    Icons.person_add,
                    color: isExpired ? TossColors.grey500 : TossColors.blue500,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${invitation.userName}님의 초대',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isExpired ? TossColors.grey500 : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        invitation.relationshipType?.name ?? '보호자',
                        style: TextStyle(
                          fontSize: 14,
                          color: isExpired ? TossColors.grey400 : TossColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.calendar_today,
              _getTimeAgo(invitation.createdAt),
              isExpired,
            ),
            if (isExpired) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: TossColors.red100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: TossColors.red500),
                    SizedBox(width: 8),
                    Text(
                      '초대가 만료되었습니다',
                      style: TextStyle(
                        fontSize: 12,
                        color: TossColors.red500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectInvitation(invitation),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: TossColors.grey300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        '거절',
                        style: TextStyle(
                          fontSize: 16,
                          color: TossColors.grey700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _acceptInvitation(invitation),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.blue500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text(
                        '수락',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value, bool isExpired) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isExpired ? TossColors.grey400 : TossColors.grey500,
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isExpired ? TossColors.grey400 : TossColors.grey600,
          ),
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}

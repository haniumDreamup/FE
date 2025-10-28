import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/services/guardian_service.dart';
import '../../../data/models/guardian_model.dart';

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
  final _guardianService = GuardianService();
  bool _isLoading = true;
  GuardianModel? _guardian;

  @override
  void initState() {
    super.initState();
    _loadGuardianData();
  }

  Future<void> _loadGuardianData() async {
    try {
      // Guardian 목록을 가져와서 해당 ID의 Guardian을 찾음
      final guardians = await _guardianService.getMyGuardians();
      final guardianId = int.tryParse(widget.guardianId);

      if (guardianId != null) {
        final guardian = guardians.firstWhere(
          (g) => g.id == guardianId,
          orElse: () => throw Exception('보호자 정보를 찾을 수 없습니다'),
        );

        if (mounted) {
          setState(() {
            _guardian = guardian;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('보호자 정보 조회 실패: ${e.toString()}'),
            backgroundColor: TossTheme.errorColor,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _sendNotification() async {
    final message = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('알림 보내기'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '보낼 메시지를 입력하세요',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('보내기'),
            ),
          ],
        );
      },
    );

    if (message != null && message.isNotEmpty && mounted) {
      setState(() => _isLoading = true);

      try {
        // TODO: 백엔드 알림 API 연동
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('알림을 보냈습니다'),
              backgroundColor: TossTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('알림 전송 실패: $e'),
              backgroundColor: TossTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _editPermissions() async {
    if (_guardian == null) return;

    final result = await showDialog<Map<String, bool>>(
      context: context,
      builder: (context) {
        bool canViewLocation = _guardian!.canViewLocation;
        bool canModifySettings = _guardian!.canModifySettings;
        bool canReceiveAlerts = _guardian!.canReceiveAlerts;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('권한 설정'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('위치 정보 접근'),
                    value: canViewLocation,
                    onChanged: (value) {
                      setState(() => canViewLocation = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('설정 변경'),
                    value: canModifySettings,
                    onChanged: (value) {
                      setState(() => canModifySettings = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('알림 수신'),
                    value: canReceiveAlerts,
                    onChanged: (value) {
                      setState(() => canReceiveAlerts = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'canViewLocation': canViewLocation,
                      'canModifySettings': canModifySettings,
                      'canReceiveAlerts': canReceiveAlerts,
                    });
                  },
                  child: const Text('저장'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      setState(() => _isLoading = true);

      try {
        await _guardianService.updateGuardianPermissions(
          int.parse(widget.guardianId),
          GuardianPermissionUpdateRequest(
            canViewLocation: result['canViewLocation']!,
            canModifySettings: result['canModifySettings']!,
            canReceiveAlerts: result['canReceiveAlerts']!,
          ),
        );

        if (mounted) {
          // 권한 업데이트 성공 후 데이터 다시 로드
          await _loadGuardianData();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('권한이 업데이트되었습니다'),
              backgroundColor: TossTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('권한 업데이트 실패: $e'),
              backgroundColor: TossTheme.errorColor,
            ),
          );
        }
      }
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

      try {
        await _guardianService.removeGuardian(int.parse(widget.guardianId));

        if (mounted) {
          Navigator.pop(context, true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('보호자가 삭제되었습니다'),
              backgroundColor: TossTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('보호자 삭제 실패: ${e.toString()}'),
              backgroundColor: TossTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '미등록';
    return DateFormat('yyyy년 M월 d일').format(date);
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return '접속 기록 없음';
    return DateFormat('yyyy년 M월 d일 a h:mm', 'ko_KR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _guardian == null) {
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
              child: Text(
                _guardian!.categoryIcon,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              _guardian!.name,
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
                color: _guardian!.isActive
                    ? TossTheme.tossGreen
                    : Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _guardian!.isActive ? '활성' : '비활성',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Approval Status
            if (_guardian!.approvalStatus != ApprovalStatus.approved)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _guardian!.approvalStatus == ApprovalStatus.pending
                      ? Colors.orange
                      : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _guardian!.statusDisplay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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
                  if (_guardian!.email != null)
                    _buildInfoCard(
                      icon: Icons.email,
                      title: '이메일',
                      value: _guardian!.email!,
                    ),
                  if (_guardian!.email != null) const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.phone,
                    title: '전화번호',
                    value: _guardian!.primaryPhone,
                  ),
                  const SizedBox(height: 12),

                  if (_guardian!.secondaryPhone != null) ...[
                    _buildInfoCard(
                      icon: Icons.phone_android,
                      title: '보조 전화번호',
                      value: _guardian!.secondaryPhone!,
                    ),
                    const SizedBox(height: 12),
                  ],

                  _buildInfoCard(
                    icon: Icons.people,
                    title: '관계',
                    value: _guardian!.relationship,
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.priority_high,
                    title: '긴급 우선순위',
                    value: '${_guardian!.emergencyPriority}순위',
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: '등록일',
                    value: _formatDate(_guardian!.createdAt),
                  ),
                  const SizedBox(height: 12),

                  _buildInfoCard(
                    icon: Icons.access_time,
                    title: '마지막 활동',
                    value: _formatDateTime(_guardian!.lastActivityAt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Permissions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '권한 설정',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPermissionCard(
                    icon: Icons.location_on,
                    title: '위치 정보 접근',
                    enabled: _guardian!.canViewLocation,
                  ),
                  const SizedBox(height: 8),
                  _buildPermissionCard(
                    icon: Icons.settings,
                    title: '설정 변경',
                    enabled: _guardian!.canModifySettings,
                  ),
                  const SizedBox(height: 8),
                  _buildPermissionCard(
                    icon: Icons.notifications,
                    title: '알림 수신',
                    enabled: _guardian!.canReceiveAlerts,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons (Placeholder)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: _sendNotification,
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
                      onPressed: _guardian!.approvalStatus == ApprovalStatus.approved
                          ? _editPermissions
                          : null,
                      icon: const Icon(Icons.settings),
                      label: Text(
                        _guardian!.approvalStatus == ApprovalStatus.approved
                            ? '권한 설정'
                            : '권한 설정 (승인 후 가능)',
                        style: const TextStyle(
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

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required bool enabled,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: enabled ? TossTheme.tossGreen.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? TossTheme.tossGreen : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: enabled ? TossTheme.tossGreen : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: enabled ? TossTheme.tossGreen : Colors.grey[600],
              ),
            ),
          ),
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? TossTheme.tossGreen : Colors.grey[400],
            size: 20,
          ),
        ],
      ),
    );
  }
}

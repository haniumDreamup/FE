import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/services/guardian_relationship_service.dart';
import '../../../data/models/guardian_relationship_model.dart';
import '../../providers/auth_provider.dart';

class AddGuardianScreen extends StatefulWidget {
  const AddGuardianScreen({super.key});

  @override
  State<AddGuardianScreen> createState() => _AddGuardianScreenState();
}

class _AddGuardianScreenState extends State<AddGuardianScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _relationshipController = TextEditingController();

  final _permissionKeys = {
    'canViewLocation': '위치 정보 보기',
    'canViewSchedule': '일정 보기',
    'canEditSchedule': '일정 수정',
    'canViewEmergency': '긴급 상황 알림',
    'canReceiveNotifications': '알림 받기',
  };

  final Map<String, bool> _permissions = {
    'canViewLocation': true,
    'canViewSchedule': true,
    'canEditSchedule': false,
    'canViewEmergency': true,
    'canReceiveNotifications': true,
  };

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _sendInvitation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.currentUser?.userId;

      if (userId == null) {
        throw Exception('로그인이 필요합니다');
      }

      final guardianService = GuardianRelationshipService();

      final request = GuardianInvitationRequest(
        userId: userId,
        guardianName: _relationshipController.text.trim().isEmpty
            ? '보호자'
            : _relationshipController.text.trim(),
        guardianEmail: _emailController.text.trim(),
        relationshipType: RelationshipType.other,
        permissionLevel: PermissionLevel.manage,
        permissionSettings: _permissions,
      );

      await guardianService.inviteGuardian(request);

      if (mounted) {
        ErrorHandler.showSuccessSnackBar(context, '보호자 초대를 보냈습니다');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('보호자 초대'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon & Description
                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: TossTheme.primaryColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  '보호자를 초대하세요',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '이메일로 초대장을 보내면\n보호자가 수락할 수 있습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email Input
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: '보호자 이메일',
                    hintText: 'guardian@example.com',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  style: const TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요';
                    }
                    if (!value.contains('@')) {
                      return '올바른 이메일 형식이 아닙니다';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Relationship Input
                TextFormField(
                  controller: _relationshipController,
                  decoration: InputDecoration(
                    labelText: '관계 (선택)',
                    hintText: '예: 부모, 자녀, 친구 등',
                    prefixIcon: const Icon(Icons.people),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),

                // Permissions
                const Text(
                  '권한 설정',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ..._permissionKeys.entries.map((entry) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: SwitchListTile(
                      title: Text(entry.value),
                      value: _permissions[entry.key]!,
                      onChanged: (value) {
                        setState(() {
                          _permissions[entry.key] = value;
                        });
                      },
                      activeColor: TossTheme.primaryColor,
                    ),
                  );
                }),

                const SizedBox(height: 32),

                // Send Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendInvitation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            '초대 보내기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

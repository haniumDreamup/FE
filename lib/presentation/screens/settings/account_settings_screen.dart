import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../providers/auth_provider.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  Future<void> _changePassword(BuildContext context) async {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('비밀번호 변경'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '현재 비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '새 비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '새 비밀번호 확인',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (newPasswordController.text != confirmPasswordController.text) {
                ErrorHandler.showErrorSnackBar(context, '새 비밀번호가 일치하지 않아요');
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('변경'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) {
        ErrorHandler.showSuccessSnackBar(context, '비밀번호가 변경되었어요');
      }
    }

    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Text(
          '정말로 계정을 삭제하시겠어요?\n\n'
          '모든 데이터가 영구적으로 삭제되며,\n'
          '복구할 수 없어요.',
        ),
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

    if (confirmed == true && context.mounted) {
      await Future.delayed(const Duration(seconds: 1));

      if (context.mounted) {
        final authProvider = context.read<AuthProvider>();
        await authProvider.logout();
        if (context.mounted) {
          context.go('/login');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('계정 설정'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Security Section
          _buildSectionTitle('보안'),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.lock,
            title: '비밀번호 변경',
            subtitle: '새로운 비밀번호로 변경',
            onTap: () => _changePassword(context),
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.fingerprint,
            title: '생체 인증',
            subtitle: '지문 또는 얼굴 인식',
            onTap: () {
              ErrorHandler.showInfoSnackBar(context, '준비 중입니다');
            },
          ),
          const SizedBox(height: 32),

          // Privacy Section
          _buildSectionTitle('개인정보'),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.download,
            title: '내 데이터 다운로드',
            subtitle: '저장된 모든 데이터를 다운로드',
            onTap: () {
              ErrorHandler.showInfoSnackBar(context, '준비 중입니다');
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.privacy_tip,
            title: '개인정보 처리방침',
            subtitle: '개인정보 수집 및 이용 동의',
            onTap: () {
              ErrorHandler.showInfoSnackBar(context, '준비 중입니다');
            },
          ),
          const SizedBox(height: 32),

          // Account Management Section
          _buildSectionTitle('계정 관리'),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.logout,
            iconColor: Colors.orange,
            title: '로그아웃',
            subtitle: '계정에서 로그아웃',
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('로그아웃 하시겠어요?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('로그아웃'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                final authProvider = context.read<AuthProvider>();
                await authProvider.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            context,
            icon: Icons.delete_forever,
            iconColor: Colors.red,
            title: '계정 삭제',
            subtitle: '계정 및 모든 데이터 영구 삭제',
            titleColor: Colors.red,
            onTap: () => _deleteAccount(context),
          ),
          const SizedBox(height: 32),

          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue[700],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '계정 삭제 시 모든 데이터가 영구적으로 삭제되며 복구할 수 없어요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: (iconColor ?? TossTheme.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor ?? TossTheme.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

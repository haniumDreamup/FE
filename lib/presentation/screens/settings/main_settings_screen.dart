import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../providers/auth_provider.dart';

class MainSettingsScreen extends StatelessWidget {
  const MainSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: TossTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: TossTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.currentUser?.name ?? '사용자',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.currentUser?.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.push('/profile/edit'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // App Settings
          _buildSectionTitle('앱 설정'),
          _buildSettingItem(
            context,
            icon: Icons.accessibility_new,
            title: '접근성',
            subtitle: '글자 크기, 음성 안내',
            onTap: () => context.push('/settings/accessibility'),
          ),
          _buildSettingItem(
            context,
            icon: Icons.palette,
            title: '테마',
            subtitle: '다크 모드, 색상',
            onTap: () => context.push('/settings/theme'),
          ),
          _buildSettingItem(
            context,
            icon: Icons.notifications,
            title: '알림',
            subtitle: '알림 설정',
            onTap: () => context.push('/settings/notifications'),
          ),
          _buildSettingItem(
            context,
            icon: Icons.wifi,
            title: '네트워크',
            subtitle: '서버 연결 설정',
            onTap: () => context.push('/settings/network'),
          ),

          const Divider(height: 1),

          // Account Settings
          _buildSectionTitle('계정'),
          _buildSettingItem(
            context,
            icon: Icons.lock,
            title: '비밀번호 변경',
            onTap: () {
              ErrorHandler.showInfoSnackBar(context, '비밀번호 변경 기능 준비 중입니다');
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.logout,
            title: '로그아웃',
            titleColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('로그아웃'),
                  content: const Text('로그아웃 하시겠어요?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.pop(context);
                          context.go('/login');
                        }
                      },
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 1),

          // About
          _buildSectionTitle('정보'),
          _buildSettingItem(
            context,
            icon: Icons.info,
            title: '버전 정보',
            subtitle: 'v1.0.0',
            onTap: () {},
          ),
          _buildSettingItem(
            context,
            icon: Icons.description,
            title: '이용약관',
            onTap: () {
              ErrorHandler.showInfoSnackBar(context, '이용약관 기능 준비 중입니다');
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.privacy_tip,
            title: '개인정보처리방침',
            onTap: () {
              ErrorHandler.showInfoSnackBar(context, '개인정보처리방침 기능 준비 중입니다');
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? TossTheme.primaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Colors.grey[600]))
          : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}

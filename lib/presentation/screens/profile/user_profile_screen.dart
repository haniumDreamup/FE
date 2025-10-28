import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/accessibility_provider.dart';
import '../../routes/route_names.dart';
import '../../widgets/common/accessible_button.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 3; // 내정보 탭 (0: 홈, 1: 일정, 2: 알림, 3: 내정보)

  // User data controllers - 초기값은 빈 문자열, initState에서 실제 데이터 설정
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // AuthProvider에서 실제 사용자 정보 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.currentUser;
      if (user != null) {
        setState(() {
          _nameController.text = user.fullName ?? user.username;
          _emailController.text = user.email;
          // 나머지 정보는 추후 백엔드 API에서 가져올 수 있음
          _phoneController.text = ''; // 백엔드에 추가 필요
          _birthController.text = ''; // 백엔드에 추가 필요
          _addressController.text = ''; // 백엔드에 추가 필요
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessibility = context.watch<AccessibilityProvider>();

    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: const Text(
          '프로필',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false, // 메인 탭이므로 뒤로가기 버튼 표시 안 함
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
                accessibility.speak('편집 모드로 변경됩니다');
              },
              icon: const Icon(Icons.edit, size: 28),
              tooltip: '편집',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildProfileForm(),
            const SizedBox(height: 24),
            _buildAccountSettings(),
            const SizedBox(height: 24),
            _buildDangerZone(),
          ],
        ),
      ),
      bottomNavigationBar: _isEditing
          ? _buildEditingActions()
          : BottomNavBar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                // 실제 화면 전환
                switch (index) {
                  case 0:
                    AppNavigation.toHome(context);
                    break;
                  case 1:
                    AppNavigation.toSchedule(context);
                    break;
                  case 2:
                    AppNavigation.toNotifications(context);
                    break;
                  case 3:
                    // 이미 프로필 화면이므로 아무것도 안 함
                    break;
                }
              },
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: TossColors.blue100,
                child: const Text(
                  '홍',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: TossColors.blue500,
                  ),
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: TossColors.blue500,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showProfileImageDialog();
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      iconSize: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _nameController.text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text,
            style: TextStyle(
              fontSize: 16,
              color: TossColors.grey600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: TossColors.green100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '활성 계정',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: TossColors.green600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '개인 정보',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildFormField(
              label: '이름',
              controller: _nameController,
              icon: Icons.person,
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            _buildFormField(
              label: '이메일',
              controller: _emailController,
              icon: Icons.email,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildFormField(
              label: '전화번호',
              controller: _phoneController,
              icon: Icons.phone,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildFormField(
              label: '생년월일',
              controller: _birthController,
              icon: Icons.cake,
              enabled: _isEditing,
              readOnly: true,
              onTap: _isEditing ? () => _selectDate() : null,
            ),
            const SizedBox(height: 16),
            _buildFormField(
              label: '주소',
              controller: _addressController,
              icon: Icons.home,
              enabled: _isEditing,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    bool readOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: TossColors.grey700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onTap: onTap,
          style: TextStyle(
            fontSize: 16,
            color: enabled ? Colors.black : TossColors.grey600,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: enabled ? TossColors.blue500 : TossColors.grey400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: TossColors.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: TossColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: TossColors.blue500, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: TossColors.grey200),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : TossColors.grey50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label을(를) 입력해주세요';
            }
            if (label == '이메일' && !value.contains('@')) {
              return '올바른 이메일 형식을 입력해주세요';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '계정 설정',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.lock,
            title: '비밀번호 변경',
            subtitle: '계정 보안을 위해 정기적으로 변경하세요',
            onTap: () => _showPasswordChangeDialog(),
          ),
          const Divider(height: 24),
          _buildSettingItem(
            icon: Icons.security,
            title: '2단계 인증',
            subtitle: '계정 보안을 강화하세요',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                _showTwoFactorDialog();
              },
              activeColor: TossColors.blue500,
            ),
          ),
          const Divider(height: 24),
          _buildSettingItem(
            icon: Icons.notifications,
            title: '알림 설정',
            subtitle: '앱 알림을 관리하세요',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('알림 설정 화면으로 이동 (구현 예정)')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.blue100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: TossColors.blue500, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: TossColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: TossColors.grey400,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZone() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TossColors.red200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: TossColors.red500),
              const SizedBox(width: 8),
              const Text(
                '위험 구역',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TossColors.red500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AccessibleButton(
            onPressed: () => _showLogoutDialog(),
            label: '로그아웃',
            backgroundColor: TossColors.red100,
            textColor: TossColors.red500,
          ),
          const SizedBox(height: 12),
          AccessibleButton(
            onPressed: () => _showDeleteAccountDialog(),
            label: '계정 삭제',
            backgroundColor: TossColors.red500,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildEditingActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AccessibleButton(
              onPressed: () {
                setState(() {
                  _isEditing = false;
                });
                context.read<AccessibilityProvider>().speak('편집이 취소되었습니다');
              },
              label: '취소',
              backgroundColor: TossColors.grey200,
              textColor: TossColors.grey700,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AccessibleButton(
              onPressed: () => _saveProfile(),
              label: '저장',
              backgroundColor: TossColors.blue500,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TossColors.blue500,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isEditing = false;
      });

      context.read<AccessibilityProvider>().speak('프로필이 저장되었습니다');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('프로필이 저장되었습니다'),
          backgroundColor: TossColors.green500,
        ),
      );
    }
  }

  void _showProfileImageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필 사진 변경'),
        content: Text('프로필 사진 변경 기능을 구현 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('비밀번호 변경'),
        content: Text('비밀번호 변경 기능을 구현 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('2단계 인증'),
        content: Text('2단계 인증 설정 기능을 구현 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
            },
            style: TextButton.styleFrom(foregroundColor: TossColors.red500),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: Text('계정을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.\n정말 계정을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('계정 삭제 기능은 구현 예정입니다'),
                  backgroundColor: TossColors.orange500,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: TossColors.red500),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
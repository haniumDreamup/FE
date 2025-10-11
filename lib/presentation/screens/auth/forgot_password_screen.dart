import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 찾기'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          // Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: TossTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 50,
                color: TossTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Title
          const Text(
            '비밀번호를 잊으셨나요?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            '이메일 주소를 입력하시면\n비밀번호 재설정 링크를 보내드려요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),

          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: '이메일',
              hintText: 'example@email.com',
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(fontSize: 16),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이메일을 입력해주세요';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return '올바른 이메일 형식이 아니에요';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Send Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendResetEmail,
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
                      '이메일 보내기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Back to Login
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                '로그인으로 돌아가기',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 80),
        // Success Icon
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: TossTheme.successColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 60,
              color: TossTheme.successColor,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Success Title
        const Text(
          '이메일을 보냈어요!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Success Description
        Text(
          '${_emailController.text}로\n비밀번호 재설정 링크를 보냈어요.\n\n이메일을 확인해주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),

        // Back to Login Button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TossTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '로그인하러 가기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Resend Email
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _emailSent = false;
              });
            },
            child: const Text(
              '이메일을 다시 보내기',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

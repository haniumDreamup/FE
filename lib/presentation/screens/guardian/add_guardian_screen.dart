import 'package:flutter/material.dart';
import '../../../core/utils/error_handler.dart';

class AddGuardianScreen extends StatelessWidget {
  const AddGuardianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('보호자 초대')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            const Text('보호자 초대 기능 준비 중입니다', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => ErrorHandler.showInfoSnackBar(context, '준비 중입니다'),
              child: const Text('보호자 초대하기'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/utils/error_handler.dart';

class AddGeofenceScreen extends StatelessWidget {
  const AddGeofenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('안전구역 추가')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            const Text('안전구역 추가 기능 준비 중입니다', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => ErrorHandler.showInfoSnackBar(context, '준비 중입니다'),
              child: const Text('안전구역 추가하기'),
            ),
          ],
        ),
      ),
    );
  }
}

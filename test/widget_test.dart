import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:bifai_app/main.dart';
import 'package:bifai_app/core/services/notification_service.dart';

void main() {
  setUpAll(() async {
    // .env 파일 로드
    dotenv.testLoad(fileInput: '''
API_BASE_URL=http://localhost:8080
ENABLE_LOGGING=false
    ''');
  });

  testWidgets('BifAiApp 앱 실행 테스트', (WidgetTester tester) async {
    // NotificationService 모의 객체 생성
    final notificationService = NotificationService();

    // 앱 빌드 및 프레임 트리거
    await tester.pumpWidget(BifAiApp(notificationService: notificationService));

    // 앱이 정상적으로 빌드되었는지 확인
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('로그인 화면 표시 테스트', (WidgetTester tester) async {
    final notificationService = NotificationService();

    await tester.pumpWidget(BifAiApp(notificationService: notificationService));
    await tester.pumpAndSettle();

    // 홈 화면 또는 로그인 화면이 표시되는지 확인
    // 초기 라우트가 /splash이므로 Splash 화면이 표시될 것
    expect(find.byType(Scaffold), findsWidgets);
  });
}

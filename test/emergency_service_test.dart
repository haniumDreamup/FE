import 'package:flutter_test/flutter_test.dart';
import 'package:bifai_app/data/models/emergency_model.dart';

void main() {
  group('Emergency 모델 테스트', () {

    test('SOSRequest 모델 생성 및 직렬화 테스트', () {
      // Given: SOS 요청 데이터
      final sosRequest = SOSRequest(
        latitude: 37.5665,
        longitude: 126.9780,
        address: '서울특별시 중구',
        message: '도움이 필요합니다',
        emergencyType: 'PANIC',
        notifyAllContacts: true,
        shareLocation: true,
      );

      // When: JSON으로 변환
      final json = sosRequest.toJson();

      // Then: 필수 필드가 올바르게 직렬화됨
      expect(json['latitude'], 37.5665);
      expect(json['longitude'], 126.9780);
      expect(json['emergencyType'], 'PANIC');
      expect(json['notifyAllContacts'], true);
    });

    test('FallDetectionRequest 모델 생성 및 직렬화 테스트', () {
      // Given: 낙상 감지 요청 데이터
      final fallRequest = FallDetectionRequest(
        confidence: 85.5,
        latitude: 37.5665,
        longitude: 126.9780,
        additionalInfo: '강한 충격 감지',
      );

      // When: JSON으로 변환
      final json = fallRequest.toJson();

      // Then: 필수 필드가 올바르게 직렬화됨
      expect(json['confidence'], 85.5);
      expect(json['latitude'], 37.5665);
      expect(json['longitude'], 126.9780);
      expect(json['additionalInfo'], '강한 충격 감지');
    });

    test('SOSResponse 모델 역직렬화 테스트', () {
      // Given: 서버 응답 JSON
      final json = {
        'emergencyId': 123,
        'status': 'TRIGGERED',
        'message': 'SOS가 발동되었습니다',
        'triggeredAt': '2025-10-02 14:30:00',
        'notifiedContacts': 3,
        'notifiedContactNames': ['홍길동', '김철수', '이영희'],
        'locationShared': true,
        'estimatedResponseTime': '5분',
        'emergencyNumber': '119',
        'simpleInstruction': '안전한 곳에서 기다려주세요',
        'success': true,
      };

      // When: JSON에서 모델 생성
      final response = SOSResponse.fromJson(json);

      // Then: 모든 필드가 올바르게 역직렬화됨
      expect(response.emergencyId, 123);
      expect(response.status, 'TRIGGERED');
      expect(response.message, 'SOS가 발동되었습니다');
      expect(response.notifiedContacts, 3);
      expect(response.notifiedContactNames?.length, 3);
      expect(response.locationShared, true);
      expect(response.success, true);
    });

    test('SOSHistory 모델 상태 표시 테스트', () {
      // Given: 해결된 긴급상황 이력
      final history = SOSHistory(
        emergencyId: 1,
        status: 'RESOLVED',
        severity: 'HIGH',
        triggeredAt: '2025-10-02 14:30:00',
      );

      // When: 상태 표시명 조회
      final statusDisplay = history.statusDisplay;
      final severityDisplay = history.severityDisplay;

      // Then: 한글로 올바르게 변환됨
      expect(statusDisplay, '해결됨');
      expect(severityDisplay, '높음');
    });

    test('EmergencyResponse 모델 역직렬화 테스트', () {
      // Given: 서버 응답 JSON
      final json = {
        'id': 1,
        'userId': 100,
        'userName': '홍길동',
        'type': 'fallDetection',
        'typeDescription': '낙상 감지',
        'status': 'TRIGGERED',
        'statusDescription': '발동됨',
        'latitude': 37.5665,
        'longitude': 126.9780,
        'address': '서울특별시 중구',
        'description': '낙상이 감지되었습니다',
        'severity': 'HIGH',
        'severityDescription': '높음',
        'triggeredBy': 'SYSTEM',
        'fallConfidence': 85.5,
        'createdAt': '2025-10-02T14:30:00',
        'notificationSent': true,
        'responderCount': 3,
      };

      // When: JSON에서 모델 생성
      final response = EmergencyResponse.fromJson(json);

      // Then: 모든 필드가 올바르게 역직렬화됨
      expect(response.id, 1);
      expect(response.userName, '홍길동');
      expect(response.latitude, 37.5665);
      expect(response.longitude, 126.9780);
      expect(response.fallConfidence, 85.5);
      expect(response.notificationSent, true);
    });

    test('EmergencyType enum 변환 테스트', () {
      // Given: 다양한 긴급상황 타입 코드
      final fallCode = 'FALL_DETECTION';
      final panicCode = 'PANIC_BUTTON';
      final medicalCode = 'MEDICAL';

      // When: 코드에서 enum으로 변환
      final fallType = EmergencyType.fromCode(fallCode);
      final panicType = EmergencyType.fromCode(panicCode);
      final medicalType = EmergencyType.fromCode(medicalCode);

      // Then: 올바른 enum으로 변환됨
      expect(fallType.displayName, '낙상 감지');
      expect(panicType.displayName, '긴급 버튼');
      expect(medicalType.displayName, '의료 긴급');
      expect(fallType.emoji, '🚨');
    });

    test('알 수 없는 EmergencyType 처리 테스트', () {
      // Given: 알 수 없는 타입 코드
      final unknownCode = 'UNKNOWN_TYPE';

      // When: 코드에서 enum으로 변환
      final type = EmergencyType.fromCode(unknownCode);

      // Then: 기타(other)로 변환됨
      expect(type, EmergencyType.other);
      expect(type.displayName, '기타');
    });

    test('EmergencyCallRequest 모델 테스트', () {
      // Given: 긴급 호출 요청
      final request = EmergencyCallRequest(
        type: 'FALL',
        description: '넘어졌어요',
        latitude: 37.5665,
        longitude: 126.9780,
        severity: 'HIGH',
        fallConfidence: 90.0,
      );

      // When: 위치 정보 확인
      final hasLocation = request.hasLocation;
      final typeDisplay = request.emergencyTypeDisplay;

      // Then: 올바르게 동작함
      expect(hasLocation, true);
      expect(typeDisplay, '낙상');
    });

    test('EmergencyContactModel 우선순위 정렬 테스트', () {
      // Given: 여러 긴급 연락처
      final contacts = [
        EmergencyContactModel(
          id: 1,
          name: '김철수',
          relationship: 'friend',
          phoneNumber: '010-1111-1111',
          priority: 3,
          isPrimary: false,
          isActive: true,
        ),
        EmergencyContactModel(
          id: 2,
          name: '홍길동',
          relationship: 'family',
          phoneNumber: '010-2222-2222',
          priority: 1,
          isPrimary: true,
          isActive: true,
        ),
        EmergencyContactModel(
          id: 3,
          name: '이영희',
          relationship: 'guardian',
          phoneNumber: '010-3333-3333',
          priority: 2,
          isPrimary: false,
          isActive: true,
        ),
      ];

      // When: 우선순위로 정렬
      contacts.sort((a, b) => a.priority.compareTo(b.priority));

      // Then: 우선순위 순서대로 정렬됨
      expect(contacts[0].name, '홍길동');
      expect(contacts[0].priority, 1);
      expect(contacts[1].name, '이영희');
      expect(contacts[2].name, '김철수');
    });

    test('주 연락처 표시 테스트', () {
      // Given: 주 연락처
      final contact = EmergencyContactModel(
        id: 1,
        name: '홍길동',
        relationship: 'family',
        phoneNumber: '010-1234-5678',
        isPrimary: true,
        isActive: true,
      );

      // When: 표시명 조회
      final displayName = contact.displayName;

      // Then: (주 연락처) 표시가 추가됨
      expect(displayName, '홍길동 (주 연락처)');
    });

    test('ContactType enum 아이콘 및 설명 테스트', () {
      // When & Then: 각 타입별로 올바른 아이콘과 설명이 있음
      expect(ContactType.family.icon, '👨‍👩‍👧‍👦');
      expect(ContactType.family.description, '가족');

      expect(ContactType.doctor.icon, '👨‍⚕️');
      expect(ContactType.doctor.description, '의사');

      expect(ContactType.emergencyService.icon, '🚑');
      expect(ContactType.emergencyService.description, '응급서비스');
    });

    test('빈 SOSHistory 리스트 처리 테스트', () {
      // Given: 빈 이력 리스트
      final List<SOSHistory> historyList = [];

      // When: 리스트 확인
      final isEmpty = historyList.isEmpty;
      final length = historyList.length;

      // Then: 비어있음
      expect(isEmpty, true);
      expect(length, 0);
    });
  });

  group('모델 엣지 케이스 테스트', () {
    test('null 값이 있는 SOSHistory 처리', () {
      // Given: 최소한의 필드만 있는 이력
      final history = SOSHistory(
        emergencyId: 1,
        triggeredAt: '2025-10-02 14:30:00',
      );

      // When & Then: null 필드 처리가 정상적으로 동작
      expect(history.emergencyId, 1);
      expect(history.status, null);
      expect(history.description, null);
      expect(history.statusDisplay, '알 수 없음'); // null일 때 기본값
    });

    test('매우 높은 confidence 값 처리', () {
      // Given: confidence가 100인 낙상 감지
      final request = FallDetectionRequest(
        confidence: 100.0,
      );

      // When: JSON 변환
      final json = request.toJson();

      // Then: 정상 처리됨
      expect(json['confidence'], 100.0);
    });

    test('음수 좌표 값 처리 (남반구/서반구)', () {
      // Given: 음수 좌표
      final request = SOSRequest(
        latitude: -33.8688, // 시드니
        longitude: 151.2093,
      );

      // When: JSON 변환
      final json = request.toJson();

      // Then: 정상 처리됨
      expect(json['latitude'], -33.8688);
      expect(json['longitude'], 151.2093);
    });

    test('매우 긴 메시지 처리', () {
      // Given: 긴 메시지
      final longMessage = '도움이 필요합니다 ' * 50; // 긴 메시지
      final request = SOSRequest(
        latitude: 37.5665,
        longitude: 126.9780,
        message: longMessage,
      );

      // When: JSON 변환
      final json = request.toJson();

      // Then: 정상 처리됨
      expect(json['message'], longMessage);
      expect(json['message'].length, greaterThan(100));
    });
  });

  group('비즈니스 로직 테스트', () {
    test('긴급 연락처 활성/비활성 필터링', () {
      // Given: 활성 및 비활성 연락처 혼합
      final contacts = [
        EmergencyContactModel(
          id: 1,
          name: '활성연락처',
          relationship: 'family',
          phoneNumber: '010-1111-1111',
          isActive: true,
          isPrimary: false,
        ),
        EmergencyContactModel(
          id: 2,
          name: '비활성연락처',
          relationship: 'friend',
          phoneNumber: '010-2222-2222',
          isActive: false,
          isPrimary: false,
        ),
      ];

      // When: 활성 연락처만 필터링
      final activeContacts = contacts.where((c) => c.isActive).toList();

      // Then: 활성 연락처만 남음
      expect(activeContacts.length, 1);
      expect(activeContacts[0].name, '활성연락처');
    });

    test('SOS 요청 기본값 테스트', () {
      // Given: 기본값만 사용한 SOS 요청
      final request = SOSRequest(
        latitude: 37.5665,
        longitude: 126.9780,
      );

      // When: JSON 변환
      final json = request.toJson();

      // Then: 기본값이 올바르게 설정됨
      expect(json['notifyAllContacts'], true);
      expect(json['shareLocation'], true);
      expect(json['requestAmbulance'], false);
    });

    test('긴급상황 알림 전송 여부 확인', () {
      // Given: 알림이 전송된 긴급상황
      final response = EmergencyResponse(
        id: 1,
        userId: 100,
        userName: '홍길동',
        type: EmergencyType.panicButton,
        typeDescription: '긴급 버튼',
        status: EmergencyStatus.notified,
        statusDescription: '알림 전송됨',
        createdAt: '2025-10-02T14:30:00',
        notificationSent: true,
        responderCount: 3,
      );

      // When & Then: 알림 상태 확인
      expect(response.notificationSent, true);
      expect(response.responderCount, 3);
      expect(response.status, EmergencyStatus.notified);
    });
  });
}

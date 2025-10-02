import 'package:flutter_test/flutter_test.dart';
import 'package:bifai_app/data/models/guardian_relationship_model.dart';

void main() {
  group('GuardianRelationship 모델 테스트', () {
    test('GuardianRelationshipDto 생성 및 직렬화 테스트', () {
      // Given: 보호자 관계 데이터
      final relationship = GuardianRelationshipDto(
        relationshipId: 1,
        guardianId: 100,
        guardianName: '김보호',
        guardianEmail: 'guardian@example.com',
        userId: 1,
        userName: '홍길동',
        relationshipType: RelationshipType.parent,
        permissionLevel: PermissionLevel.full,
        status: RelationshipStatus.active,
        emergencyPriority: 1,
        createdAt: '2025-10-02T14:30:00',
      );

      // When: JSON으로 변환
      final json = relationship.toJson();

      // Then: 필수 필드가 올바르게 직렬화됨
      expect(json['relationshipId'], 1);
      expect(json['guardianName'], '김보호');
      expect(json['userName'], '홍길동');
    });

    test('관계 타입 한글 표시 테스트', () {
      // Given: 다양한 관계 타입
      final parent = GuardianRelationshipDto(
        relationshipId: 1,
        guardianId: 1,
        guardianName: '부모',
        guardianEmail: 'test@test.com',
        userId: 1,
        userName: '사용자',
        relationshipType: RelationshipType.parent,
        permissionLevel: PermissionLevel.full,
        status: RelationshipStatus.active,
        createdAt: '2025-10-02T14:30:00',
      );

      final friend = GuardianRelationshipDto(
        relationshipId: 2,
        guardianId: 2,
        guardianName: '친구',
        guardianEmail: 'friend@test.com',
        userId: 1,
        userName: '사용자',
        relationshipType: RelationshipType.friend,
        permissionLevel: PermissionLevel.viewOnly,
        status: RelationshipStatus.active,
        createdAt: '2025-10-02T14:30:00',
      );

      // When & Then: 한글 표시명이 올바름
      expect(parent.relationshipTypeDisplay, '부모');
      expect(friend.relationshipTypeDisplay, '친구');
    });

    test('권한 레벨 한글 표시 테스트', () {
      // Given: 다양한 권한 레벨
      final levels = [
        PermissionLevel.viewOnly,
        PermissionLevel.manage,
        PermissionLevel.emergency,
        PermissionLevel.full,
      ];

      final displays = ['읽기 전용', '관리', '긴급 상황만', '전체 권한'];

      // When & Then: 각 레벨의 한글 표시가 올바름
      for (int i = 0; i < levels.length; i++) {
        final relationship = GuardianRelationshipDto(
          relationshipId: i,
          guardianId: i,
          guardianName: '테스트',
          guardianEmail: 'test@test.com',
          userId: 1,
          userName: '사용자',
          relationshipType: RelationshipType.other,
          permissionLevel: levels[i],
          status: RelationshipStatus.active,
          createdAt: '2025-10-02T14:30:00',
        );
        expect(relationship.permissionLevelDisplay, displays[i]);
      }
    });

    test('관계 상태 한글 표시 테스트', () {
      // Given: 다양한 상태
      final statuses = [
        RelationshipStatus.pending,
        RelationshipStatus.active,
        RelationshipStatus.suspended,
        RelationshipStatus.rejected,
        RelationshipStatus.expired,
        RelationshipStatus.terminated,
      ];

      final displays = ['대기 중', '활성', '일시 중지', '거부됨', '만료됨', '종료됨'];

      // When & Then: 각 상태의 한글 표시가 올바름
      for (int i = 0; i < statuses.length; i++) {
        final relationship = GuardianRelationshipDto(
          relationshipId: i,
          guardianId: i,
          guardianName: '테스트',
          guardianEmail: 'test@test.com',
          userId: 1,
          userName: '사용자',
          relationshipType: RelationshipType.other,
          permissionLevel: PermissionLevel.viewOnly,
          status: statuses[i],
          createdAt: '2025-10-02T14:30:00',
        );
        expect(relationship.statusDisplay, displays[i]);
      }
    });

    test('활성 상태 확인 테스트', () {
      // Given: 활성 및 비활성 관계
      final active = GuardianRelationshipDto(
        relationshipId: 1,
        guardianId: 1,
        guardianName: '활성',
        guardianEmail: 'active@test.com',
        userId: 1,
        userName: '사용자',
        relationshipType: RelationshipType.parent,
        permissionLevel: PermissionLevel.full,
        status: RelationshipStatus.active,
        createdAt: '2025-10-02T14:30:00',
      );

      final suspended = GuardianRelationshipDto(
        relationshipId: 2,
        guardianId: 2,
        guardianName: '중지',
        guardianEmail: 'suspended@test.com',
        userId: 1,
        userName: '사용자',
        relationshipType: RelationshipType.friend,
        permissionLevel: PermissionLevel.viewOnly,
        status: RelationshipStatus.suspended,
        createdAt: '2025-10-02T14:30:00',
      );

      // When & Then: 활성 상태만 true
      expect(active.isActive, true);
      expect(suspended.isActive, false);
    });

    test('GuardianInvitationRequest 생성 및 직렬화 테스트', () {
      // Given: 초대 요청 데이터
      final request = GuardianInvitationRequest(
        userId: 1,
        guardianName: '김보호',
        guardianEmail: 'guardian@example.com',
        guardianPhone: '010-1234-5678',
        relationshipType: RelationshipType.parent,
        permissionLevel: PermissionLevel.full,
        emergencyPriority: 1,
        notes: '주 보호자',
      );

      // When: JSON으로 변환
      final json = request.toJson();

      // Then: 필수 필드가 올바르게 직렬화됨
      expect(json['userId'], 1);
      expect(json['guardianName'], '김보호');
      expect(json['guardianEmail'], 'guardian@example.com');
      expect(json['emergencyPriority'], 1);
    });

    test('GuardianInvitationResponse 역직렬화 테스트', () {
      // Given: 서버 응답 JSON
      final json = {
        'relationshipId': 1,
        'invitationToken': 'abc123token',
        'expiresAt': '2025-10-09T14:30:00',
        'guardianEmail': 'guardian@example.com',
        'status': 'PENDING',
        'invitationUrl': 'https://app.example.com/invite/abc123token',
      };

      // When: JSON에서 모델 생성
      final response = GuardianInvitationResponse.fromJson(json);

      // Then: 모든 필드가 올바르게 역직렬화됨
      expect(response.relationshipId, 1);
      expect(response.invitationToken, 'abc123token');
      expect(response.guardianEmail, 'guardian@example.com');
      expect(response.status, 'PENDING');
      expect(response.invitationUrl, isNotNull);
    });

    test('PermissionUpdateRequest 생성 및 직렬화 테스트', () {
      // Given: 권한 업데이트 요청
      final request = PermissionUpdateRequest(
        permissionLevel: PermissionLevel.manage,
        permissionSettings: {
          'canViewLocation': true,
          'canViewSchedule': true,
          'canViewMedication': false,
        },
      );

      // When: JSON으로 변환
      final json = request.toJson();

      // Then: 필드가 올바르게 직렬화됨
      expect(json['permissionSettings'], isNotNull);
      expect(json['permissionSettings']['canViewLocation'], true);
      expect(json['permissionSettings']['canViewMedication'], false);
    });

    test('EmergencyContactDto 역직렬화 테스트', () {
      // Given: 긴급 연락처 JSON
      final json = {
        'guardianId': 100,
        'guardianName': '김응급',
        'guardianEmail': 'emergency@example.com',
        'guardianPhone': '010-9999-9999',
        'emergencyPriority': 1,
        'relationshipType': 'PARENT',
        'canReceiveEmergencyAlerts': true,
      };

      // When: JSON에서 모델 생성
      final contact = EmergencyContactDto.fromJson(json);

      // Then: 모든 필드가 올바르게 역직렬화됨
      expect(contact.guardianId, 100);
      expect(contact.guardianName, '김응급');
      expect(contact.emergencyPriority, 1);
      expect(contact.canReceiveEmergencyAlerts, true);
    });

    test('권한 설정 Map 처리 테스트', () {
      // Given: 상세한 권한 설정이 있는 관계
      final relationship = GuardianRelationshipDto(
        relationshipId: 1,
        guardianId: 1,
        guardianName: '테스트',
        guardianEmail: 'test@test.com',
        userId: 1,
        userName: '사용자',
        relationshipType: RelationshipType.parent,
        permissionLevel: PermissionLevel.manage,
        status: RelationshipStatus.active,
        permissionSettings: {
          'canViewLocation': true,
          'canViewSchedule': true,
          'canViewMedication': true,
          'canEditSchedule': false,
          'canEditMedication': false,
        },
        createdAt: '2025-10-02T14:30:00',
      );

      // When: JSON 변환
      final json = relationship.toJson();

      // Then: 권한 설정이 올바르게 직렬화됨
      expect(json['permissionSettings'], isNotNull);
      expect(json['permissionSettings']['canViewLocation'], true);
      expect(json['permissionSettings']['canEditSchedule'], false);
    });
  });

  group('엣지 케이스 테스트', () {
    test('null 옵셔널 필드 처리', () {
      // Given: 최소 필드만 있는 관계
      final relationship = GuardianRelationshipDto(
        relationshipId: 1,
        guardianId: 1,
        guardianName: '테스트',
        guardianEmail: 'test@test.com',
        userId: 1,
        userName: '사용자',
        relationshipType: RelationshipType.other,
        permissionLevel: PermissionLevel.viewOnly,
        status: RelationshipStatus.pending,
        createdAt: '2025-10-02T14:30:00',
      );

      // When & Then: null 필드가 정상 처리됨
      expect(relationship.permissionSettings, null);
      expect(relationship.emergencyPriority, null);
      expect(relationship.notes, null);
      expect(relationship.approvedAt, null);
    });

    test('빈 권한 설정 Map 처리', () {
      // Given: 빈 권한 설정
      final relationship = GuardianRelationshipDto(
        relationshipId: 1,
        guardianId: 1,
        guardianName: '테스트',
        guardianEmail: 'test@test.com',
        userId: 1,
        userName: '사용자',
        relationshipType: RelationshipType.other,
        permissionLevel: PermissionLevel.viewOnly,
        status: RelationshipStatus.active,
        permissionSettings: {},
        createdAt: '2025-10-02T14:30:00',
      );

      // When & Then: 빈 Map이 정상 처리됨
      expect(relationship.permissionSettings, isNotNull);
      expect(relationship.permissionSettings!.isEmpty, true);
    });

    test('우선순위 경계값 테스트', () {
      // Given: 최소/최대 우선순위
      final minPriority = GuardianRelationshipDto(
        relationshipId: 1,
        guardianId: 1,
        guardianName: '테스트',
        guardianEmail: 'test@test.com',
        userId: 1,
        userName: '사용자',
        relationshipType: RelationshipType.other,
        permissionLevel: PermissionLevel.emergency,
        status: RelationshipStatus.active,
        emergencyPriority: 1,
        createdAt: '2025-10-02T14:30:00',
      );

      final maxPriority = GuardianRelationshipDto(
        relationshipId: 2,
        guardianId: 2,
        guardianName: '테스트2',
        guardianEmail: 'test2@test.com',
        userId: 1,
        userName: '사용자',
        relationshipType: RelationshipType.other,
        permissionLevel: PermissionLevel.emergency,
        status: RelationshipStatus.active,
        emergencyPriority: 10,
        createdAt: '2025-10-02T14:30:00',
      );

      // When & Then: 경계값이 정상 처리됨
      expect(minPriority.emergencyPriority, 1);
      expect(maxPriority.emergencyPriority, 10);
    });

    test('전화번호 형식 패턴 테스트', () {
      // Given: 다양한 전화번호 형식
      final phones = [
        '010-1234-5678',
        '02-123-4567',
        '031-1234-5678',
      ];

      // When: 각 번호로 요청 생성
      for (final phone in phones) {
        final request = GuardianInvitationRequest(
          userId: 1,
          guardianName: '테스트',
          guardianEmail: 'test@test.com',
          guardianPhone: phone,
          relationshipType: RelationshipType.other,
          permissionLevel: PermissionLevel.viewOnly,
        );

        // Then: 전화번호가 정상 저장됨
        expect(request.guardianPhone, phone);
      }
    });
  });
}

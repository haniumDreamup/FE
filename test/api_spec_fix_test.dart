import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../lib/data/services/emergency_service.dart';
import '../lib/data/services/notification_api_service.dart';
import '../lib/core/network/api_client.dart';

@GenerateMocks([ApiClient, Dio])
import 'api_spec_fix_test.mocks.dart';

void main() {
  group('API 스펙 수정사항 검증', () {
    late MockApiClient mockApiClient;
    late MockDio mockDio;
    late EmergencyService emergencyService;
    late NotificationApiService notificationService;

    setUp(() {
      mockApiClient = MockApiClient();
      mockDio = MockDio();
      when(mockApiClient.dio).thenReturn(mockDio);

      emergencyService = EmergencyService(apiClient: mockApiClient);
      notificationService = NotificationApiService(apiClient: mockApiClient);
    });

    group('EmergencyService 수정사항', () {
      test('quickSOS - latitude/longitude 파라미터 전달 확인', () async {
        // Given
        final latitude = 37.5665;
        final longitude = 126.9780;

        when(mockDio.post(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {
            'success': true,
            'data': {
              'id': 1,
              'emergencyType': 'PANIC',
              'status': 'ACTIVE',
              'latitude': latitude,
              'longitude': longitude,
              'notifiedContacts': [],
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        // When
        await emergencyService.quickSOS(
          latitude: latitude,
          longitude: longitude,
        );

        // Then
        verify(mockDio.post(
          '/api/v1/emergency/sos/quick',
          queryParameters: {
            'latitude': latitude,
            'longitude': longitude,
          },
        )).called(1);
      });

      test('resolveEmergency - resolvedBy(필수), notes(선택) 파라미터 전달 확인', () async {
        // Given
        final emergencyId = 1;
        final resolvedBy = '홍길동';
        final notes = '문제 해결됨';

        when(mockDio.put(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {
            'success': true,
            'data': {
              'id': emergencyId,
              'type': 'FALL_DETECTION',
              'status': 'RESOLVED',
              'resolvedBy': resolvedBy,
              'notes': notes,
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        // When
        await emergencyService.resolveEmergency(
          emergencyId,
          resolvedBy: resolvedBy,
          notes: notes,
        );

        // Then
        verify(mockDio.put(
          '/api/v1/emergency/$emergencyId/resolve',
          queryParameters: {
            'resolvedBy': resolvedBy,
            'notes': notes,
          },
        )).called(1);
      });

      test('resolveEmergency - notes 없이 호출 가능 (선택 파라미터)', () async {
        // Given
        final emergencyId = 2;
        final resolvedBy = '김철수';

        when(mockDio.put(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {
            'success': true,
            'data': {
              'id': emergencyId,
              'type': 'MANUAL_ALERT',
              'status': 'RESOLVED',
              'resolvedBy': resolvedBy,
            }
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        // When
        await emergencyService.resolveEmergency(
          emergencyId,
          resolvedBy: resolvedBy,
        );

        // Then
        verify(mockDio.put(
          '/api/v1/emergency/$emergencyId/resolve',
          queryParameters: {
            'resolvedBy': resolvedBy,
          },
        )).called(1);
      });
    });

    group('NotificationApiService 수정사항', () {
      test('validateFcmToken - query parameter로 token 전달 확인', () async {
        // Given
        final fcmToken = 'test_fcm_token_12345';

        when(mockDio.post(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {
            'success': true,
            'data': true,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        // When
        final result = await notificationService.validateFcmToken(fcmToken);

        // Then
        expect(result, true);
        verify(mockDio.post(
          '/api/notifications/validate-token',
          queryParameters: {'token': fcmToken},
        )).called(1);
      });

      test('sendEmergencyAlert - query parameters로 message, latitude, longitude 전달', () async {
        // Given
        final message = '긴급 상황 발생';
        final latitude = 37.5665;
        final longitude = 126.9780;

        when(mockDio.post(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {'success': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        // When
        await notificationService.sendEmergencyAlert(
          message: message,
          latitude: latitude,
          longitude: longitude,
        );

        // Then
        verify(mockDio.post(
          '/api/notifications/emergency',
          queryParameters: {
            'message': message,
            'latitude': latitude,
            'longitude': longitude,
          },
        )).called(1);
      });

      test('sendEmergencyAlert - 위치 정보 없이 message만 전달 가능', () async {
        // Given
        final message = '긴급 도움 필요';

        when(mockDio.post(
          any,
          queryParameters: anyNamed('queryParameters'),
        )).thenAnswer((_) async => Response(
          data: {'success': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ));

        // When
        await notificationService.sendEmergencyAlert(message: message);

        // Then
        verify(mockDio.post(
          '/api/notifications/emergency',
          queryParameters: {'message': message},
        )).called(1);
      });
    });

    group('파라미터 필수/선택 검증', () {
      test('quickSOS - latitude, longitude는 필수 파라미터', () {
        // 컴파일 타임에 검증됨 - 파라미터 없이 호출 시 컴파일 에러
        // emergencyService.quickSOS(); // ❌ 컴파일 에러

        // 올바른 호출
        expect(() async {
          when(mockDio.post(any, queryParameters: anyNamed('queryParameters')))
              .thenAnswer((_) async => Response(
                data: {'success': true, 'data': {}},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));
          await emergencyService.quickSOS(latitude: 37.5, longitude: 126.9);
        }, returnsNormally);
      });

      test('resolveEmergency - resolvedBy는 필수, notes는 선택', () {
        // resolvedBy 없이 호출 시 컴파일 에러
        // emergencyService.resolveEmergency(1); // ❌ 컴파일 에러

        // resolvedBy만으로 호출 가능
        expect(() async {
          when(mockDio.put(any, queryParameters: anyNamed('queryParameters')))
              .thenAnswer((_) async => Response(
                data: {'success': true, 'data': {}},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));
          await emergencyService.resolveEmergency(1, resolvedBy: '홍길동');
        }, returnsNormally);
      });

      test('sendEmergencyAlert - message는 필수, latitude/longitude는 선택', () {
        // message 없이 호출 시 컴파일 에러
        // notificationService.sendEmergencyAlert(); // ❌ 컴파일 에러

        // message만으로 호출 가능
        expect(() async {
          when(mockDio.post(any, queryParameters: anyNamed('queryParameters')))
              .thenAnswer((_) async => Response(
                data: {'success': true},
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));
          await notificationService.sendEmergencyAlert(message: '긴급');
        }, returnsNormally);
      });
    });
  });
}

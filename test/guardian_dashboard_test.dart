import 'package:flutter_test/flutter_test.dart';
import 'package:bifai_app/data/models/guardian_dashboard_model.dart';

void main() {
  group('GuardianDashboard 모델 테스트', () {
    test('DailyStatusSummary 모델 생성 및 직렬화 테스트', () {
      // Given: 오늘의 상태 요약 데이터
      final dailySummary = DailyStatusSummary(
        userId: 1,
        userName: '홍길동',
        summaryDate: '2025-10-02T14:30:00',
        overallStatus: 'GOOD',
        statusMessage: '모든 상태가 정상입니다',
      );

      // When: JSON으로 변환
      final json = dailySummary.toJson();

      // Then: 필수 필드가 올바르게 직렬화됨
      expect(json['userId'], 1);
      expect(json['userName'], '홍길동');
      expect(json['overallStatus'], 'GOOD');
      expect(json['statusMessage'], '모든 상태가 정상입니다');
    });

    test('DailyStatusSummary 상태 표시명 테스트', () {
      // Given: 다양한 상태의 요약
      final goodSummary = DailyStatusSummary(
        userId: 1,
        userName: '테스트',
        summaryDate: '2025-10-02T14:30:00',
        overallStatus: 'GOOD',
        statusMessage: '좋음',
      );

      final attentionSummary = DailyStatusSummary(
        userId: 1,
        userName: '테스트',
        summaryDate: '2025-10-02T14:30:00',
        overallStatus: 'ATTENTION_NEEDED',
        statusMessage: '주의 필요',
      );

      final warningSummary = DailyStatusSummary(
        userId: 1,
        userName: '테스트',
        summaryDate: '2025-10-02T14:30:00',
        overallStatus: 'WARNING',
        statusMessage: '경고',
      );

      // When & Then: 상태별 표시명과 색상이 올바름
      expect(goodSummary.statusDisplayName, '좋음');
      expect(goodSummary.statusColor, 'green');

      expect(attentionSummary.statusDisplayName, '주의 필요');
      expect(attentionSummary.statusColor, 'orange');

      expect(warningSummary.statusDisplayName, '경고');
      expect(warningSummary.statusColor, 'red');
    });

    test('MedicationStatus 모델 역직렬화 테스트', () {
      // Given: 복약 상태 JSON
      final json = {
        'totalMedications': 5,
        'takenMedications': 4,
        'missedMedications': 1,
        'completionRate': 80.0,
        'nextMedicationTime': '18:00',
        'nextMedicationName': '비타민 D',
      };

      // When: JSON에서 모델 생성
      final status = MedicationStatus.fromJson(json);

      // Then: 모든 필드가 올바르게 역직렬화됨
      expect(status.totalMedications, 5);
      expect(status.takenMedications, 4);
      expect(status.missedMedications, 1);
      expect(status.completionRate, 80.0);
      expect(status.completionRateDisplay, '80%');
      expect(status.statusColor, 'green'); // 80% 이상이므로 green
    });

    test('MedicationStatus 상태 색상 테스트', () {
      // Given: 다양한 완료율의 복약 상태
      final highCompletion = MedicationStatus(
        totalMedications: 10,
        takenMedications: 9,
        missedMedications: 1,
        completionRate: 90.0,
      );

      final mediumCompletion = MedicationStatus(
        totalMedications: 10,
        takenMedications: 6,
        missedMedications: 4,
        completionRate: 60.0,
      );

      final lowCompletion = MedicationStatus(
        totalMedications: 10,
        takenMedications: 3,
        missedMedications: 7,
        completionRate: 30.0,
      );

      // When & Then: 완료율에 따라 색상이 다름
      expect(highCompletion.statusColor, 'green'); // >= 80%
      expect(mediumCompletion.statusColor, 'orange'); // >= 50%
      expect(lowCompletion.statusColor, 'red'); // < 50%
    });

    test('LocationStatus 업데이트 시간 표시 테스트', () {
      // Given: 다양한 경과 시간
      final justNow = LocationStatus(
        currentLocation: '집',
        lastUpdated: '2025-10-02T14:30:00',
        isInSafeZone: true,
        minutesSinceUpdate: 0,
      );

      final minutes = LocationStatus(
        currentLocation: '회사',
        lastUpdated: '2025-10-02T14:15:00',
        isInSafeZone: true,
        minutesSinceUpdate: 15,
      );

      final hours = LocationStatus(
        currentLocation: '카페',
        lastUpdated: '2025-10-02T12:00:00',
        isInSafeZone: false,
        minutesSinceUpdate: 150,
      );

      // When & Then: 경과 시간 표시가 올바름
      expect(justNow.updateTimeDisplay, '방금 전');
      expect(minutes.updateTimeDisplay, '15분 전');
      expect(hours.updateTimeDisplay, '2시간 전');
    });

    test('ActivityStatus 활동 시간 표시 테스트', () {
      // Given: 다양한 활동 시간
      final shortActivity = ActivityStatus(
        lastActiveTime: '2025-10-02T14:30:00',
        totalActiveMinutes: 30,
        screenTimeMinutes: 10,
        activityLevel: 'LOW',
        isCurrentlyActive: false,
      );

      final longActivity = ActivityStatus(
        lastActiveTime: '2025-10-02T14:30:00',
        totalActiveMinutes: 150,
        screenTimeMinutes: 50,
        activityLevel: 'HIGH',
        isCurrentlyActive: true,
      );

      // When & Then: 시간 표시가 올바름
      expect(shortActivity.activeTimeDisplay, '30분');
      expect(longActivity.activeTimeDisplay, '2시간 30분');
      expect(shortActivity.activityLevelDisplay, '낮음');
      expect(longActivity.activityLevelDisplay, '높음');
    });

    test('ScheduleStatus 완료율 계산 테스트', () {
      // Given: 일정 상태
      final scheduleStatus = ScheduleStatus(
        totalSchedules: 10,
        completedSchedules: 7,
        upcomingSchedules: 3,
        nextScheduleTime: '16:00',
        nextScheduleTitle: '운동하기',
      );

      final noSchedule = ScheduleStatus(
        totalSchedules: 0,
        completedSchedules: 0,
        upcomingSchedules: 0,
      );

      // When: 완료율 계산
      final rate = scheduleStatus.completionRate;
      final noRate = noSchedule.completionRate;

      // Then: 완료율이 올바름
      expect(rate, 70.0);
      expect(scheduleStatus.completionRateDisplay, '70%');
      expect(noRate, 0.0);
    });

    test('WeeklySummary 모델 역직렬화 테스트', () {
      // Given: 주간 요약 JSON
      final json = {
        'userId': 1,
        'userName': '홍길동',
        'weekStartDate': '2025-09-29',
        'weekEndDate': '2025-10-05',
        'weeklyTrend': 'IMPROVING',
        'concerns': ['복약 시간 주의', '수면 패턴 불규칙'],
        'achievements': ['일정 100% 완료', '활동량 증가'],
      };

      // When: JSON에서 모델 생성
      final summary = WeeklySummary.fromJson(json);

      // Then: 모든 필드가 올바르게 역직렬화됨
      expect(summary.userId, 1);
      expect(summary.userName, '홍길동');
      expect(summary.weeklyTrend, 'IMPROVING');
      expect(summary.concerns.length, 2);
      expect(summary.achievements.length, 2);
      expect(summary.trendDisplayName, '개선 중');
      expect(summary.trendIcon, '📈');
    });

    test('WeeklySummary 트렌드 표시 테스트', () {
      // Given: 다양한 트렌드
      final improving = WeeklySummary(
        userId: 1,
        userName: '테스트',
        weekStartDate: '2025-09-29',
        weekEndDate: '2025-10-05',
        weeklyTrend: 'IMPROVING',
        concerns: [],
        achievements: [],
      );

      final stable = WeeklySummary(
        userId: 1,
        userName: '테스트',
        weekStartDate: '2025-09-29',
        weekEndDate: '2025-10-05',
        weeklyTrend: 'STABLE',
        concerns: [],
        achievements: [],
      );

      final declining = WeeklySummary(
        userId: 1,
        userName: '테스트',
        weekStartDate: '2025-09-29',
        weekEndDate: '2025-10-05',
        weeklyTrend: 'DECLINING',
        concerns: [],
        achievements: [],
      );

      // When & Then: 트렌드별 표시명과 아이콘이 올바름
      expect(improving.trendDisplayName, '개선 중');
      expect(improving.trendIcon, '📈');

      expect(stable.trendDisplayName, '안정적');
      expect(stable.trendIcon, '➡️');

      expect(declining.trendDisplayName, '주의 필요');
      expect(declining.trendIcon, '📉');
    });

    test('MedicationWeeklySummary 모델 테스트', () {
      // Given: 복약 주간 요약
      final summary = MedicationWeeklySummary(
        overallCompletionRate: 85.5,
        dailyRates: {
          '2025-10-01': 90.0,
          '2025-10-02': 80.0,
        },
        totalMedications: 35,
        missedMedications: 5,
        frequentlyMissed: ['혈압약', '당뇨약'],
        bestDay: '2025-10-01',
        worstDay: '2025-10-02',
      );

      // When & Then: 표시가 올바름
      expect(summary.completionRateDisplay, '86%');
      expect(summary.frequentlyMissed.length, 2);
    });

    test('ActivityWeeklySummary 평균 시간 표시 테스트', () {
      // Given: 활동 주간 요약
      final summary = ActivityWeeklySummary(
        totalActiveMinutes: 1050,
        dailyAverageMinutes: 150.0,
        dailyActivity: {},
        inactiveDays: 1,
        activityPatterns: ['아침형', '꾸준한 활동'],
      );

      final shortAverage = ActivityWeeklySummary(
        totalActiveMinutes: 210,
        dailyAverageMinutes: 30.0,
        dailyActivity: {},
        inactiveDays: 2,
        activityPatterns: [],
      );

      // When & Then: 평균 시간 표시가 올바름
      expect(summary.averageTimeDisplay, '2시간 30분');
      expect(shortAverage.averageTimeDisplay, '30분');
    });

    test('IntegratedDashboard 모델 생성 테스트', () {
      // Given: 통합 대시보드 데이터
      final dailySummary = DailyStatusSummary(
        userId: 1,
        userName: '홍길동',
        summaryDate: '2025-10-02T14:30:00',
        overallStatus: 'GOOD',
        statusMessage: '좋음',
      );

      final weeklySummary = WeeklySummary(
        userId: 1,
        userName: '홍길동',
        weekStartDate: '2025-09-29',
        weekEndDate: '2025-10-05',
        weeklyTrend: 'STABLE',
        concerns: [],
        achievements: [],
      );

      final dashboard = IntegratedDashboard(
        userId: 1,
        userName: '홍길동',
        dailySummary: dailySummary,
        weeklySummary: weeklySummary,
        lastUpdated: '2025-10-02T14:30:00',
      );

      // When: JSON 변환
      final json = dashboard.toJson();

      // Then: 통합 대시보드가 올바르게 생성됨
      expect(json['userId'], 1);
      expect(json['userName'], '홍길동');
      expect(json['dailySummary'], isNotNull);
      expect(json['weeklySummary'], isNotNull);
    });
  });

  group('엣지 케이스 테스트', () {
    test('null 옵셔널 필드 처리', () {
      // Given: 최소 필드만 있는 요약
      final summary = DailyStatusSummary(
        userId: 1,
        userName: '테스트',
        summaryDate: '2025-10-02T14:30:00',
        overallStatus: 'GOOD',
        statusMessage: '좋음',
        // 모든 옵셔널 필드 null
      );

      // When & Then: null 필드가 정상 처리됨
      expect(summary.medicationStatus, null);
      expect(summary.locationStatus, null);
      expect(summary.activityStatus, null);
      expect(summary.scheduleStatus, null);
    });

    test('빈 리스트 처리', () {
      // Given: 빈 리스트
      final summary = WeeklySummary(
        userId: 1,
        userName: '테스트',
        weekStartDate: '2025-09-29',
        weekEndDate: '2025-10-05',
        weeklyTrend: 'STABLE',
        concerns: [],
        achievements: [],
      );

      // When & Then: 빈 리스트가 정상 처리됨
      expect(summary.concerns.isEmpty, true);
      expect(summary.achievements.isEmpty, true);
    });

    test('완료율 100% 처리', () {
      // Given: 100% 완료
      final medication = MedicationStatus(
        totalMedications: 10,
        takenMedications: 10,
        missedMedications: 0,
        completionRate: 100.0,
      );

      // When & Then: 100% 완료가 정상 처리됨
      expect(medication.completionRate, 100.0);
      expect(medication.completionRateDisplay, '100%');
      expect(medication.statusColor, 'green');
    });

    test('0건 완료 처리', () {
      // Given: 0% 완료
      final medication = MedicationStatus(
        totalMedications: 10,
        takenMedications: 0,
        missedMedications: 10,
        completionRate: 0.0,
      );

      // When & Then: 0% 완료가 정상 처리됨
      expect(medication.completionRate, 0.0);
      expect(medication.completionRateDisplay, '0%');
      expect(medication.statusColor, 'red');
    });
  });
}

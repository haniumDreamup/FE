import 'package:flutter/material.dart';
import '../../../core/config/toss_theme.dart';
import '../../widgets/common/accessible_button.dart';

class StatisticsDashboardScreen extends StatefulWidget {
  const StatisticsDashboardScreen({super.key});

  @override
  State<StatisticsDashboardScreen> createState() => _StatisticsDashboardScreenState();
}

class _StatisticsDashboardScreenState extends State<StatisticsDashboardScreen> {
  String _selectedPeriod = '이번 주';
  final List<String> _periods = ['오늘', '이번 주', '이번 달', '3개월'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: const Text(
          '통계',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.calendar_today, size: 24),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => _periods.map((period) {
              return PopupMenuItem(
                value: period,
                child: Row(
                  children: [
                    Icon(
                      _selectedPeriod == period ? Icons.check : Icons.calendar_today_outlined,
                      size: 20,
                      color: _selectedPeriod == period ? TossColors.blue500 : TossColors.grey600,
                    ),
                    const SizedBox(width: 8),
                    Text(period),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            _buildOverviewCards(),
            const SizedBox(height: 24),
            _buildMedicationStats(),
            const SizedBox(height: 24),
            _buildScheduleStats(),
            const SizedBox(height: 24),
            _buildEmergencyStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              const Icon(Icons.bar_chart, color: TossColors.blue500, size: 24),
              const SizedBox(width: 8),
              const Text(
                '통계 기간',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: _periods.map((period) {
              final isSelected = _selectedPeriod == period;
              return FilterChip(
                label: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? Colors.white : TossColors.grey700,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
                backgroundColor: TossColors.grey100,
                selectedColor: TossColors.blue500,
                checkmarkColor: Colors.white,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '전체 요약',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '복용률',
                '87%',
                Icons.medication,
                TossColors.green500,
                '어제보다 +3%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '일정 완료',
                '15/18',
                Icons.check_circle,
                TossColors.blue500,
                '83% 완료',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '긴급 호출',
                '0회',
                Icons.emergency,
                TossColors.red500,
                '평화로운 $_selectedPeriod',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '활동 점수',
                '92점',
                Icons.star,
                TossColors.orange500,
                '훌륭해요!',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: TossColors.grey600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              const Icon(Icons.medication, color: TossColors.green500, size: 24),
              const SizedBox(width: 8),
              const Text(
                '복용 통계',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressItem('아침약 복용', 0.9, '6/7일'),
          const SizedBox(height: 16),
          _buildProgressItem('점심약 복용', 0.8, '5/7일'),
          const SizedBox(height: 16),
          _buildProgressItem('저녁약 복용', 0.85, '6/7일'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossColors.green50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.trending_up, color: TossColors.green500),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '복용률이 지난주보다 5% 향상되었어요!',
                    style: TextStyle(
                      fontSize: 14,
                      color: TossColors.green700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              const Icon(Icons.schedule, color: TossColors.blue500, size: 24),
              const SizedBox(width: 8),
              const Text(
                '일정 통계',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildScheduleTypeCard('병원 방문', '3회', TossColors.blue500),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildScheduleTypeCard('운동', '5회', TossColors.green500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildScheduleTypeCard('식사', '18회', TossColors.orange500),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildScheduleTypeCard('기타', '7회', TossColors.grey500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTypeCard(String type, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            type,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              const Icon(Icons.security, color: TossColors.red500, size: 24),
              const SizedBox(width: 8),
              const Text(
                '안전 통계',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossColors.green50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: TossColors.green500, size: 32),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '안전한 기간',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: TossColors.green700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '긴급 상황 없이 30일째',
                        style: TextStyle(
                          fontSize: 14,
                          color: TossColors.green600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AccessibleButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('상세 보고서 기능 구현 예정')),
              );
            },
            label: '상세 보고서 보기',
            backgroundColor: TossColors.blue500,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, double progress, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              details,
              style: const TextStyle(
                fontSize: 12,
                color: TossColors.grey600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: TossColors.grey200,
          valueColor: const AlwaysStoppedAnimation<Color>(TossColors.green500),
          minHeight: 6,
        ),
      ],
    );
  }
}
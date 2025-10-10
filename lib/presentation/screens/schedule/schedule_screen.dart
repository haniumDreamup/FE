import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/schedule_model.dart';
import '../../providers/schedule_provider.dart';
import '../../routes/route_names.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import 'add_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 1; // 일정 탭 (0: 홈, 1: 일정, 2: 알림, 3: 내정보)

  @override
  void initState() {
    super.initState();
    // 화면 로드 시 오늘의 일정 조회
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleProvider>().loadTodaySchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('일정'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              AppNavigation.toScheduleAdd(context);
              // GoRouter는 자동으로 뒤로가기 처리하므로 별도 리프레시 로직 필요
              // 화면 재진입 시 initState에서 자동으로 로드됨
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ScheduleProvider>(
          builder: (context, scheduleProvider, child) {
            if (scheduleProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (scheduleProvider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      scheduleProvider.errorMessage!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        scheduleProvider.clearError();
                        scheduleProvider.loadTodaySchedules();
                      },
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              );
            }

            final todaySchedules = scheduleProvider.todaySchedules;

            return RefreshIndicator(
              onRefresh: () => scheduleProvider.loadTodaySchedules(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
            // Calendar Preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '오늘',
                        style: TextStyle(
                          color: TossTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final date = DateTime.now().add(Duration(days: index - 3));
                      final isToday = index == 3;
                      return Column(
                        children: [
                          Text(
                            _getWeekdayName(date.weekday),
                            style: TextStyle(
                              fontSize: 12,
                              color: isToday ? TossTheme.primaryColor : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isToday ? TossTheme.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  color: isToday ? Colors.white : Colors.black,
                                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Today's Schedule
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '오늘의 일정',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${todaySchedules.length}개',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (todaySchedules.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '오늘 예정된 일정이 없습니다',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...todaySchedules.map((schedule) => _ScheduleItem(
                schedule: schedule,
                onTap: () => _showScheduleDetail(schedule),
                onComplete: () => _toggleScheduleComplete(schedule),
              )),
          ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
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
              // 이미 일정 화면이므로 아무것도 안 함
              break;
            case 2:
              AppNavigation.toNotifications(context);
              break;
            case 3:
              AppNavigation.toProfile(context);
              break;
          }
        },
      ),
    );
  }

  void _showScheduleDetail(ScheduleResponse schedule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  schedule.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (schedule.description != null) ...[
              Text(
                schedule.description!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 16),
            ],
            _DetailRow(
              icon: Icons.access_time,
              label: '시간',
              value: schedule.executionTime,
            ),
            _DetailRow(
              icon: Icons.category,
              label: '유형',
              value: schedule.scheduleTypeDescription,
            ),
            _DetailRow(
              icon: Icons.repeat,
              label: '반복',
              value: schedule.recurrenceTypeDescription,
            ),
            if (schedule.nextExecutionTime != null)
              _DetailRow(
                icon: Icons.schedule,
                label: '다음 실행',
                value: _formatDateTime(schedule.nextExecutionDateTime!),
              ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(schedule);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TossTheme.errorColor,
                      side: const BorderSide(color: TossTheme.errorColor),
                    ),
                    child: const Text('삭제'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: GoRouter로 일정 ID를 전달하는 방식으로 개선 필요
                      // 현재는 AddScheduleScreen이 editSchedule 파라미터를 받도록 되어 있어
                      // GoRouter의 extra 파라미터 사용 필요
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddScheduleScreen(editSchedule: schedule),
                        ),
                      );
                    },
                    child: const Text('수정'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleScheduleComplete(ScheduleResponse schedule) {
    final provider = context.read<ScheduleProvider>();
    // Note: Backend spec doesn't indicate completed status in response
    // This is a placeholder - need to check actual API response structure
    provider.completeSchedule(schedule.id);
  }

  void _confirmDelete(ScheduleResponse schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('일정 삭제'),
        content: Text('${schedule.title}\n일정을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context.read<ScheduleProvider>().deleteSchedule(schedule.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? '일정이 삭제되었습니다' : '삭제에 실패했습니다'),
                    backgroundColor: success ? TossTheme.successColor : TossTheme.errorColor,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: TossTheme.errorColor),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }
}

class _ScheduleItem extends StatelessWidget {
  final ScheduleResponse schedule;
  final VoidCallback onTap;
  final VoidCallback onComplete;

  const _ScheduleItem({
    required this.schedule,
    required this.onTap,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(schedule.scheduleType);
    final icon = _getTypeIcon(schedule.scheduleType);
    final isCompleted = false; // TODO: Check actual completion status from backend

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? Colors.grey.shade300 : Colors.grey.shade200,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            schedule.executionTime,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (schedule.isHighPriority)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: TossTheme.errorColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '중요',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: TossTheme.errorColor,
                                ),
                              ),
                            ),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: TossTheme.successColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                '완료',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: TossTheme.successColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        schedule.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        schedule.simpleDescription,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isCompleted ? Icons.check_circle : Icons.circle_outlined,
                    color: isCompleted ? TossTheme.successColor : Colors.grey,
                  ),
                  onPressed: onComplete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(ScheduleType type) {
    switch (type) {
      case ScheduleType.medication:
        return const Color(0xFF2196F3);
      case ScheduleType.meal:
        return const Color(0xFFFF9800);
      case ScheduleType.exercise:
        return const Color(0xFF4CAF50);
      case ScheduleType.appointment:
        return TossTheme.primaryColor;
      case ScheduleType.therapy:
        return const Color(0xFF9C27B0);
      case ScheduleType.hygiene:
        return const Color(0xFF00BCD4);
      case ScheduleType.safetyCheck:
        return TossTheme.errorColor;
      case ScheduleType.socialActivity:
        return const Color(0xFFFF5722);
      case ScheduleType.personalCare:
        return const Color(0xFF795548);
      case ScheduleType.reminder:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(ScheduleType type) {
    switch (type) {
      case ScheduleType.medication:
        return Icons.medication;
      case ScheduleType.meal:
        return Icons.restaurant;
      case ScheduleType.exercise:
        return Icons.fitness_center;
      case ScheduleType.appointment:
        return Icons.local_hospital;
      case ScheduleType.therapy:
        return Icons.accessibility_new;
      case ScheduleType.hygiene:
        return Icons.clean_hands;
      case ScheduleType.safetyCheck:
        return Icons.verified_user;
      case ScheduleType.socialActivity:
        return Icons.people;
      case ScheduleType.personalCare:
        return Icons.self_improvement;
      case ScheduleType.reminder:
        return Icons.notifications;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
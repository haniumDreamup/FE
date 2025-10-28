import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/schedule_model.dart';
import '../../providers/schedule_provider.dart';
import '../../routes/route_names.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 1; // 일정 탭 (0: 홈, 1: 일정, 2: 알림, 3: 내정보)
  DateTime _selectedDate = DateTime.now();

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
            onPressed: () async {
              final result = await context.push('/schedule/add');
              // 일정 추가 성공 시 리프레시
              if (result == true && mounted) {
                print('📅 [ScheduleScreen] 일정 추가 완료, 리프레시 시작');
                if (_isToday(_selectedDate)) {
                  context.read<ScheduleProvider>().loadTodaySchedules();
                } else {
                  context.read<ScheduleProvider>().loadSchedulesByDate(_selectedDate);
                }
              }
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

            final displayedSchedules = scheduleProvider.displayedSchedules;
            final isToday = _isToday(_selectedDate);

            return RefreshIndicator(
              onRefresh: () {
                if (isToday) {
                  return scheduleProvider.loadTodaySchedules();
                } else {
                  return scheduleProvider.loadSchedulesByDate(_selectedDate);
                }
              },
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
                      final isSelected = _selectedDate.year == date.year &&
                                        _selectedDate.month == date.month &&
                                        _selectedDate.day == date.day;
                      return GestureDetector(
                        onTap: () {
                          print('📅 [ScheduleScreen] 날짜 클릭: ${date.year}-${date.month}-${date.day}');
                          setState(() {
                            _selectedDate = date;
                          });
                          // 선택한 날짜의 일정 조회
                          if (isToday) {
                            print('📅 [ScheduleScreen] 오늘 날짜 선택 → loadTodaySchedules 호출');
                            context.read<ScheduleProvider>().loadTodaySchedules();
                          } else {
                            print('📅 [ScheduleScreen] 다른 날짜 선택 → loadSchedulesByDate 호출');
                            context.read<ScheduleProvider>().loadSchedulesByDate(date);
                          }
                        },
                        child: Column(
                          children: [
                            Text(
                              _getWeekdayName(date.weekday),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? TossTheme.primaryColor : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected ? TossTheme.primaryColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: isToday && !isSelected
                                    ? Border.all(color: TossTheme.primaryColor, width: 2)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    color: isSelected ? Colors.white :
                                           isToday ? TossTheme.primaryColor : Colors.black,
                                    fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Schedule List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isToday ? '오늘의 일정' : '${_selectedDate.month}월 ${_selectedDate.day}일 일정',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${displayedSchedules.length}개',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (displayedSchedules.isEmpty)
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
                        isToday ? '오늘 예정된 일정이 없습니다' : '선택한 날짜에 일정이 없습니다',
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
              ...displayedSchedules.map((schedule) => _ScheduleItem(
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
                      context.push('/schedule/${schedule.id}/edit');
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

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return today.isAtSameMomentAs(checkDate);
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: false ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: false ? Colors.grey.shade300 : Colors.grey.shade200,
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
                          if (false)
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
                    false ? Icons.check_circle : Icons.circle_outlined,
                    color: false ? TossTheme.successColor : Colors.grey,
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
      case ScheduleType.emergencyCheck:
        return TossTheme.errorColor;
      case ScheduleType.healthCheck:
        return const Color(0xFF9C27B0);
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
      case ScheduleType.emergencyCheck:
        return Icons.verified_user;
      case ScheduleType.healthCheck:
        return Icons.health_and_safety;
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
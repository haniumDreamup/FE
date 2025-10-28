import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/config/toss_theme.dart';
import '../../routes/route_names.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/home/quick_action_card.dart';
import '../../widgets/home/today_summary_card.dart';
import '../../widgets/emergency/sos_floating_button.dart';
import '../../providers/accessibility_provider.dart';
import '../../providers/schedule_provider.dart';
import '../../../data/models/schedule_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  DateTime? _lastBackPressed;
  bool _isLoading = true;
  List<ScheduleResponse> _todaySchedules = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodaySchedules();
    });
  }

  Future<void> _loadTodaySchedules() async {
    try {
      final scheduleProvider = context.read<ScheduleProvider>();
      await scheduleProvider.loadTodaySchedules();
      if (mounted) {
        setState(() {
          _todaySchedules = scheduleProvider.todaySchedules;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
            _lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
          _lastBackPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('뒤로 버튼을 한 번 더 누르면 앱이 종료됩니다'),
              duration: Duration(seconds: 2),
              backgroundColor: TossTheme.tossGray800,
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
      backgroundColor: TossTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('BIF-AI'),
        actions: [
          Consumer<AccessibilityProvider>(
            builder: (context, accessibility, child) {
              return IconButton(
                icon: Icon(
                  accessibility.voiceGuidanceEnabled
                      ? Icons.volume_up
                      : Icons.volume_off,
                ),
                tooltip: accessibility.voiceGuidanceEnabled
                    ? '음성 안내 끄기'
                    : '음성 안내 켜기',
                onPressed: () async {
                  await accessibility.setVoiceGuidanceEnabled(
                    !accessibility.voiceGuidanceEnabled,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          accessibility.voiceGuidanceEnabled
                              ? '음성 안내를 켰어요'
                              : '음성 안내를 껐어요',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => AppNavigation.toNotifications(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      TossTheme.primaryColor,
                      TossTheme.primaryColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '좋은 아침이에요! 👋',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Today's Summary
              const Text(
                '오늘의 할 일',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _isLoading
                  ? Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => AppNavigation.toSchedule(context),
                      child: _todaySchedules.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.event_available,
                                      size: 48,
                                      color: TossTheme.tossGray400,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '오늘 예정된 일정이 없어요',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: TossTheme.tossGray600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '탭해서 일정을 추가하세요',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: TossTheme.tossGray400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : TodaySummaryCard(
                              schedulesToday: _todaySchedules.length,
                              nextEventTitle: _todaySchedules.first.title ?? '일정',
                              nextEventTime: _todaySchedules.first.executionTime != null
                                  ? '${_todaySchedules.first.executionTime![0].toString().padLeft(2, '0')}:${_todaySchedules.first.executionTime![1].toString().padLeft(2, '0')}'
                                  : '--:--',
                            ),
                    ),
              const SizedBox(height: 24),
              
              // Quick Actions
              const Text(
                '빠른 실행',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  QuickActionCard(
                    title: '일정 확인',
                    icon: Icons.calendar_today,
                    color: TossTheme.primaryColor,
                    onTap: () => AppNavigation.toSchedule(context),
                  ),
                  QuickActionCard(
                    title: '일정 추가',
                    icon: Icons.add_box_rounded,
                    color: TossTheme.tossBlue,
                    onTap: () => AppNavigation.toScheduleAdd(context),
                  ),
                  QuickActionCard(
                    title: '긴급 연락',
                    icon: Icons.emergency,
                    color: TossTheme.errorColor,
                    onTap: () => AppNavigation.toEmergency(context),
                  ),
                  QuickActionCard(
                    title: '보호자 연락',
                    icon: Icons.phone,
                    color: TossTheme.warningColor,
                    onTap: () => AppNavigation.toGuardians(context),
                  ),
                  QuickActionCard(
                    title: '사진 도우미',
                    icon: Icons.camera_alt,
                    color: TossTheme.infoColor,
                    onTap: () => AppNavigation.toAiVision(context),
                  ),
                  QuickActionCard(
                    title: '실시간 카메라',
                    icon: Icons.videocam,
                    color: TossTheme.tossPurple,
                    onTap: () => AppNavigation.toWearableCamera(context),
                  ),
                  QuickActionCard(
                    title: '하드웨어 검색',
                    icon: Icons.router_rounded,
                    color: TossTheme.tossOrange,
                    onTap: () => AppNavigation.toNetworkDiscovery(context),
                  ),
                  QuickActionCard(
                    title: '설정',
                    icon: Icons.settings_rounded,
                    color: TossTheme.tossGray700,
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const SOSFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              AppNavigation.toHome(context);
              break;
            case 1:
              AppNavigation.toSchedule(context);
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
      ),
    );
  }
}
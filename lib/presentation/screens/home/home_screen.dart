import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/toss_theme.dart';
import '../../routes/route_names.dart';
import '../../widgets/common/bottom_nav_bar.dart';
import '../../widgets/home/quick_action_card.dart';
import '../../widgets/home/today_summary_card.dart';
import '../../widgets/emergency/sos_floating_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('BIF-AI'),
        actions: [
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
              const TodaySummaryCard(
                schedulesToday: 2,
                nextEventTitle: '오전 운동',
                nextEventTime: '10:00',
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
                childAspectRatio: 1.5,
                children: [
                  QuickActionCard(
                    title: '일정 확인',
                    icon: Icons.calendar_today,
                    color: TossTheme.primaryColor,
                    onTap: () => AppNavigation.toSchedule(context),
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
    );
  }
}
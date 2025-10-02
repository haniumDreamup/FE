import 'package:flutter/material.dart';
import '../../../core/config/toss_theme.dart';
import '../../routes/route_names.dart';
import '../../widgets/common/accessible_button.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  int _selectedIndex = 2; // 알림 탭 (0: 홈, 1: 일정, 2: 알림, 3: 내정보)

  // Mock data for demonstration
  final List<Map<String, dynamic>> _medicationNotifications = [
    {
      'id': 1,
      'title': '아침약 복용 시간',
      'message': '혈압약과 당뇨약을 복용할 시간입니다',
      'time': '오전 8:00',
      'isRead': false,
      'type': 'medication',
      'icon': Icons.medication,
      'color': TossColors.blue500,
    },
    {
      'id': 2,
      'title': '점심약 복용 완료',
      'message': '점심약 복용이 확인되었습니다',
      'time': '오후 1:30',
      'isRead': true,
      'type': 'medication',
      'icon': Icons.check_circle,
      'color': TossColors.green500,
    },
  ];

  final List<Map<String, dynamic>> _scheduleNotifications = [
    {
      'id': 3,
      'title': '병원 진료 예약',
      'message': '내일 오후 2시 서울대병원 신경과 진료',
      'time': '어제',
      'isRead': false,
      'type': 'schedule',
      'icon': Icons.local_hospital,
      'color': TossColors.red500,
    },
    {
      'id': 4,
      'title': '운동 시간 알림',
      'message': '오늘의 운동 계획: 산책 30분',
      'time': '오전 6:00',
      'isRead': true,
      'type': 'schedule',
      'icon': Icons.directions_walk,
      'color': TossColors.orange500,
    },
  ];

  final List<Map<String, dynamic>> _systemNotifications = [
    {
      'id': 5,
      'title': '앱 업데이트 안내',
      'message': '새로운 기능이 추가되었습니다',
      'time': '2일 전',
      'isRead': true,
      'type': 'system',
      'icon': Icons.system_update,
      'color': TossColors.grey500,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: const Text(
          '알림',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false, // 메인 탭이므로 뒤로가기 버튼 표시 안 함
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              _showNotificationSettings();
            },
            icon: const Icon(Icons.settings, size: 28),
            tooltip: '알림 설정',
          ),
          IconButton(
            onPressed: () {
              _markAllAsRead();
            },
            icon: const Icon(Icons.done_all, size: 28),
            tooltip: '모두 읽음 처리',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: TossColors.blue500,
          unselectedLabelColor: TossColors.grey600,
          indicatorColor: TossColors.blue500,
          tabs: const [
            Tab(text: '전체'),
            Tab(text: '복약'),
            Tab(text: '일정'),
            Tab(text: '시스템'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllNotifications(),
          _buildNotificationList(_medicationNotifications),
          _buildNotificationList(_scheduleNotifications),
          _buildNotificationList(_systemNotifications),
        ],
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
              AppNavigation.toSchedule(context);
              break;
            case 2:
              // 이미 알림 화면이므로 아무것도 안 함
              break;
            case 3:
              AppNavigation.toProfile(context);
              break;
          }
        },
      ),
    );
  }

  Widget _buildAllNotifications() {
    final allNotifications = [
      ..._medicationNotifications,
      ..._scheduleNotifications,
      ..._systemNotifications,
    ];
    allNotifications.sort((a, b) => a['isRead'] ? 1 : -1);

    return _buildNotificationList(allNotifications);
  }

  Widget _buildNotificationList(List<Map<String, dynamic>> notifications) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: TossColors.blue500),
            SizedBox(height: 16),
            Text(
              '알림을 불러오는 중...',
              style: TextStyle(fontSize: 16, color: TossColors.grey600),
            ),
          ],
        ),
      );
    }

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: TossColors.grey400,
            ),
            const SizedBox(height: 16),
            const Text(
              '알림이 없습니다',
              style: TextStyle(fontSize: 18, color: TossColors.grey600),
            ),
            const SizedBox(height: 8),
            const Text(
              '새로운 알림이 오면 여기에 표시됩니다',
              style: TextStyle(fontSize: 14, color: TossColors.grey500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _isLoading = false;
        });
      },
      color: TossColors.blue500,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification['isRead']
              ? Colors.transparent
              : TossColors.blue500.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _markAsRead(notification);
            _showNotificationDetail(notification);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: notification['color'].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    notification['icon'],
                    color: notification['color'],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification['isRead']
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                color: notification['isRead']
                                    ? TossColors.grey700
                                    : Colors.black,
                              ),
                            ),
                          ),
                          if (!notification['isRead'])
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: TossColors.blue500,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontSize: 14,
                          color: TossColors.grey600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notification['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: TossColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteNotification(notification);
                    } else if (value == 'mark_read') {
                      _markAsRead(notification);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!notification['isRead'])
                      const PopupMenuItem(
                        value: 'mark_read',
                        child: Row(
                          children: [
                            Icon(Icons.done, color: TossColors.green500),
                            SizedBox(width: 8),
                            Text('읽음 처리'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: TossColors.red500),
                          SizedBox(width: 8),
                          Text('삭제'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _medicationNotifications) {
        notification['isRead'] = true;
      }
      for (var notification in _scheduleNotifications) {
        notification['isRead'] = true;
      }
      for (var notification in _systemNotifications) {
        notification['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('모든 알림을 읽음 처리했습니다'),
        backgroundColor: TossColors.green500,
      ),
    );
  }

  void _deleteNotification(Map<String, dynamic> notification) {
    setState(() {
      _medicationNotifications.remove(notification);
      _scheduleNotifications.remove(notification);
      _systemNotifications.remove(notification);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('알림이 삭제되었습니다'),
        backgroundColor: TossColors.red500,
      ),
    );
  }

  void _showNotificationDetail(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(notification['icon'], color: notification['color']),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notification['title'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['message'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              '시간: ${notification['time']}',
              style: TextStyle(
                fontSize: 14,
                color: TossColors.grey600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인', style: TextStyle(color: TossColors.blue500)),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.settings, color: TossColors.blue500),
            SizedBox(width: 12),
            Text('알림 설정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AccessibleButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('복약 알림 설정 화면 구현 예정')),
                );
              },
              label: '복약 알림 설정',
              backgroundColor: TossColors.blue100,
              textColor: TossColors.blue500,
            ),
            const SizedBox(height: 12),
            AccessibleButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('일정 알림 설정 화면 구현 예정')),
                );
              },
              label: '일정 알림 설정',
              backgroundColor: TossColors.orange100,
              textColor: TossColors.orange500,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기', style: TextStyle(color: TossColors.grey600)),
          ),
        ],
      ),
    );
  }
}
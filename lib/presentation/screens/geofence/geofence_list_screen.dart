import 'package:flutter/material.dart';
import '../../../core/config/toss_theme.dart';
import '../../widgets/common/accessible_button.dart';

class GeofenceListScreen extends StatefulWidget {
  const GeofenceListScreen({super.key});

  @override
  State<GeofenceListScreen> createState() => _GeofenceListScreenState();
}

class _GeofenceListScreenState extends State<GeofenceListScreen> {
  bool _isLoading = false;

  // Mock data for demonstration
  final List<Map<String, dynamic>> _geofences = [
    {
      'id': 1,
      'name': '집',
      'address': '서울시 강남구 테헤란로 123',
      'radius': 100,
      'isActive': true,
      'type': 'home',
      'enterCount': 15,
      'exitCount': 14,
    },
    {
      'id': 2,
      'name': '병원',
      'address': '서울시 서초구 서초대로 456',
      'radius': 50,
      'isActive': true,
      'type': 'hospital',
      'enterCount': 3,
      'exitCount': 3,
    },
    {
      'id': 3,
      'name': '약국',
      'address': '서울시 강남구 강남대로 789',
      'radius': 30,
      'isActive': false,
      'type': 'pharmacy',
      'enterCount': 1,
      'exitCount': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.grey50,
      appBar: AppBar(
        title: const Text(
          '위치 관리',
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
          IconButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              // 실제로는 API 호출
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              });
            },
            icon: const Icon(Icons.refresh, size: 28),
            tooltip: '새로고침',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddGeofenceDialog();
        },
        backgroundColor: TossColors.blue500,
        icon: const Icon(Icons.add_location, size: 24),
        label: const Text('위치 추가', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: TossColors.blue500),
            SizedBox(height: 16),
            Text(
              '위치 정보를 불러오는 중...',
              style: TextStyle(fontSize: 16, color: TossColors.grey600),
            ),
          ],
        ),
      );
    }

    if (_geofences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: TossColors.grey400,
            ),
            const SizedBox(height: 16),
            const Text(
              '등록된 위치가 없습니다',
              style: TextStyle(fontSize: 18, color: TossColors.grey600),
            ),
            const SizedBox(height: 8),
            const Text(
              '하단의 + 버튼을 눌러 위치를 추가해주세요',
              style: TextStyle(fontSize: 14, color: TossColors.grey500),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildLocationStatus(),
        Expanded(
          child: RefreshIndicator(
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
              itemCount: _geofences.length,
              itemBuilder: (context, index) {
                final geofence = _geofences[index];
                return _buildGeofenceCard(geofence);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationStatus() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.blue50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TossColors.blue200),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: TossColors.blue500, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '현재 위치: 집',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: TossColors.blue700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '위치 서비스가 활성화되어 있습니다',
                  style: TextStyle(
                    fontSize: 12,
                    color: TossColors.blue600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: TossColors.green500,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeofenceCard(Map<String, dynamic> geofence) {
    final IconData typeIcon = _getGeofenceIcon(geofence['type']);
    final Color typeColor = _getGeofenceColor(geofence['type']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showGeofenceDetails(geofence);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(typeIcon, color: typeColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                geofence['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: geofence['isActive'] ? TossColors.green100 : TossColors.grey200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  geofence['isActive'] ? '활성' : '비활성',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: geofence['isActive'] ? TossColors.green600 : TossColors.grey600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            geofence['address'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: TossColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: geofence['isActive'],
                      onChanged: (value) {
                        setState(() {
                          geofence['isActive'] = value;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${geofence['name']} 위치가 ${value ? '활성화' : '비활성화'}되었습니다',
                            ),
                            backgroundColor: value ? TossColors.green500 : TossColors.grey500,
                          ),
                        );
                      },
                      activeColor: TossColors.blue500,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.radio_button_unchecked, '반경', '${geofence['radius']}m'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildCountItem('진입', geofence['enterCount'], TossColors.green500),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCountItem('이탈', geofence['exitCount'], TossColors.orange500),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AccessibleButton(
                        onPressed: () {
                          _showEditGeofenceDialog(geofence);
                        },
                        label: '편집',
                        backgroundColor: TossColors.blue100,
                        textColor: TossColors.blue500,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AccessibleButton(
                        onPressed: () {
                          _showDeleteDialog(geofence);
                        },
                        label: '삭제',
                        backgroundColor: TossColors.red100,
                        textColor: TossColors.red500,
                        height: 40,
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: TossColors.grey500),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            color: TossColors.grey600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCountItem(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
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

  IconData _getGeofenceIcon(String type) {
    switch (type) {
      case 'home':
        return Icons.home;
      case 'hospital':
        return Icons.local_hospital;
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'school':
        return Icons.school;
      case 'work':
        return Icons.work;
      default:
        return Icons.location_on;
    }
  }

  Color _getGeofenceColor(String type) {
    switch (type) {
      case 'home':
        return TossColors.blue500;
      case 'hospital':
        return TossColors.red500;
      case 'pharmacy':
        return TossColors.green500;
      case 'school':
        return TossColors.grey500;
      case 'work':
        return TossColors.orange500;
      default:
        return TossColors.grey500;
    }
  }

  void _showGeofenceDetails(Map<String, dynamic> geofence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${geofence['name']} 상세 정보'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주소: ${geofence['address']}'),
            const SizedBox(height: 8),
            Text('반경: ${geofence['radius']}m'),
            const SizedBox(height: 8),
            Text('상태: ${geofence['isActive'] ? '활성' : '비활성'}'),
            const SizedBox(height: 8),
            Text('진입 횟수: ${geofence['enterCount']}회'),
            const SizedBox(height: 8),
            Text('이탈 횟수: ${geofence['exitCount']}회'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showAddGeofenceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 위치 추가'),
        content: Text('위치 추가 기능을 구현 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showEditGeofenceDialog(Map<String, dynamic> geofence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${geofence['name']} 편집'),
        content: Text('위치 편집 기능을 구현 예정입니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> geofence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('위치 삭제'),
        content: Text('${geofence['name']} 위치를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _geofences.remove(geofence);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${geofence['name']} 위치가 삭제되었습니다'),
                  backgroundColor: TossColors.red500,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: TossColors.red500),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../core/config/toss_theme.dart';

class MedicationHistoryScreen extends StatefulWidget {
  final String medicationId;

  const MedicationHistoryScreen({
    super.key,
    required this.medicationId,
  });

  @override
  State<MedicationHistoryScreen> createState() => _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState extends State<MedicationHistoryScreen> {
  bool _isLoading = true;
  final List<Map<String, dynamic>> _historyList = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _historyList.addAll([
          {
            'date': '2024년 1월 15일',
            'time': '오전 9:00',
            'taken': true,
            'notes': '정상 복용',
          },
          {
            'date': '2024년 1월 14일',
            'time': '오전 9:00',
            'taken': true,
            'notes': '',
          },
          {
            'date': '2024년 1월 13일',
            'time': '오전 9:00',
            'taken': false,
            'notes': '복용 누락',
          },
          {
            'date': '2024년 1월 12일',
            'time': '오전 9:00',
            'taken': true,
            'notes': '',
          },
        ]);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('복용 기록'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyList.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '복용 기록이 없어요',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _historyList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final history = _historyList[index];
        final taken = history['taken'] as bool;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: taken ? Colors.white : Colors.red[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: taken ? Colors.grey[300]! : Colors.red[200]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Status Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: taken ? TossTheme.tossGreen.withOpacity(0.1) : Colors.red[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  taken ? Icons.check_circle : Icons.cancel,
                  color: taken ? TossTheme.tossGreen : Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history['date'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      history['time'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if ((history['notes'] as String).isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        history['notes'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: taken ? Colors.grey[600] : Colors.red[700],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: taken ? TossTheme.tossGreen : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  taken ? '복용' : '누락',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

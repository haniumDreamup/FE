import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();

  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _frequency = '매일';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ErrorHandler.showSuccessSnackBar(context, '약이 추가되었어요');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('약 추가하기'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Medication Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '약 이름',
                    hintText: '예: 타이레놀',
                    prefixIcon: const Icon(Icons.medication),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '약 이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Dosage
                TextFormField(
                  controller: _dosageController,
                  decoration: InputDecoration(
                    labelText: '복용량',
                    hintText: '예: 1정',
                    prefixIcon: const Icon(Icons.medical_services),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '복용량을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Frequency
                DropdownButtonFormField<String>(
                  value: _frequency,
                  decoration: InputDecoration(
                    labelText: '복용 주기',
                    prefixIcon: const Icon(Icons.repeat),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ['매일', '격일', '주 3회', '필요시']
                      .map((freq) => DropdownMenuItem(
                            value: freq,
                            child: Text(freq),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _frequency = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Time
                InkWell(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '복용 시간',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedTime.format(context),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: '메모 (선택사항)',
                    hintText: '식후 30분에 복용',
                    prefixIcon: const Icon(Icons.note),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    alignLabelWithHint: true,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveMedication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            '추가하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

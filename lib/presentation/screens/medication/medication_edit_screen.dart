import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';

class MedicationEditScreen extends StatefulWidget {
  final String medicationId;

  const MedicationEditScreen({
    super.key,
    required this.medicationId,
  });

  @override
  State<MedicationEditScreen> createState() => _MedicationEditScreenState();
}

class _MedicationEditScreenState extends State<MedicationEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();
  String _frequency = '매일';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicationData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadMedicationData() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _nameController.text = '타이레놀';
        _dosageController.text = '1정';
        _notesController.text = '식후 30분';
        _isLoading = false;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
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
      ErrorHandler.showSuccessSnackBar(context, '약물 정보가 수정되었어요');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('약물 수정')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('약물 수정'),
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
                    prefixIcon: const Icon(Icons.medication),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
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
                    hintText: '예: 1정, 1포',
                    prefixIcon: const Icon(Icons.medical_information),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '복용량을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Time
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  leading: const Icon(Icons.access_time),
                  title: const Text('복용 시간'),
                  subtitle: Text(_selectedTime.format(context)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _selectTime,
                ),
                const SizedBox(height: 16),

                // Frequency
                DropdownButtonFormField<String>(
                  value: _frequency,
                  decoration: InputDecoration(
                    labelText: '복용 빈도',
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

                // Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: '메모 (선택)',
                    hintText: '예: 식후 30분, 물과 함께',
                    prefixIcon: const Icon(Icons.notes),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveMedication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '저장하기',
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

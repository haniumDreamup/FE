import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/config/theme_config.dart';
import '../../../data/models/schedule_model.dart';
import '../../providers/schedule_provider.dart';

/// 일정 추가 화면 (BIF 사용자를 위한 간소화된 폼)
class AddScheduleScreen extends StatefulWidget {
  final ScheduleResponse? editSchedule; // 수정 시 기존 일정

  const AddScheduleScreen({
    super.key,
    this.editSchedule,
  });

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Form 데이터
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ScheduleType _selectedType = ScheduleType.reminder;
  RecurrenceType _selectedRecurrence = RecurrenceType.once;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  DateTime? _endDate;
  List<DayOfWeek> _selectedDays = [];
  int _priority = 2; // 1=낮음, 2=보통, 3=높음, 4=긴급
  int _reminderMinutes = 10;
  bool _requiresConfirmation = true;

  @override
  void initState() {
    super.initState();
    if (widget.editSchedule != null) {
      _loadExistingSchedule();
    }
  }

  void _loadExistingSchedule() {
    final schedule = widget.editSchedule!;
    _titleController.text = schedule.title;
    _descriptionController.text = schedule.description ?? '';
    _selectedType = schedule.scheduleType;
    _selectedRecurrence = schedule.recurrenceType;
    _priority = schedule.priority;
    _reminderMinutes = schedule.reminderMinutesBefore ?? 10;
    _requiresConfirmation = schedule.requiresConfirmation;

    // 시간 파싱 (HH:mm)
    final timeParts = schedule.executionTime.split(':');
    _selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    // 날짜 파싱
    if (schedule.startDate != null) {
      _selectedDate = DateTime.parse(schedule.startDate!);
    }
    if (schedule.endDate != null) {
      _endDate = DateTime.parse(schedule.endDate!);
    }
    if (schedule.selectedDays != null) {
      _selectedDays = schedule.selectedDays!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editSchedule != null;

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      appBar: AppBar(
        title: Text(isEdit ? '일정 수정' : '새 일정 추가'),
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: () => setState(() => _currentStep--),
              child: const Text('이전'),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 진행 표시기
            _buildProgressIndicator(),

            // 단계별 폼
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentStep(),
                ),
              ),
            ),

            // 하단 버튼
            _buildBottomButtons(isEdit),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive
                              ? ThemeConfig.primaryColor
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 20)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStepName(index),
                        style: TextStyle(
                          fontSize: 12,
                          color: isActive ? ThemeConfig.primaryColor : Colors.grey,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < 2)
                  Container(
                    height: 2,
                    width: 24,
                    color: index < _currentStep
                        ? ThemeConfig.primaryColor
                        : Colors.grey.shade300,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  String _getStepName(int step) {
    switch (step) {
      case 0:
        return '기본 정보';
      case 1:
        return '시간 설정';
      case 2:
        return '추가 옵션';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildTimeSettingsStep();
      case 2:
        return _buildAdditionalOptionsStep();
      default:
        return const SizedBox();
    }
  }

  // Step 1: 기본 정보
  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '일정 제목',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: '예: 병원 가기',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(16),
          ),
          style: const TextStyle(fontSize: 18),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '일정 제목을 입력해주세요';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        const Text(
          '메모 (선택사항)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            hintText: '예: 오전 9시까지 도착',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.all(16),
          ),
          style: const TextStyle(fontSize: 16),
          maxLines: 3,
        ),
        const SizedBox(height: 24),

        const Text(
          '일정 종류',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ScheduleType.values.map((type) {
            final isSelected = _selectedType == type;
            return ChoiceChip(
              label: Text(type.description),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedType = type);
                }
              },
              selectedColor: _getTypeColor(type).withOpacity(0.2),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? _getTypeColor(type) : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 2: 시간 설정
  Widget _buildTimeSettingsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '언제 할까요?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RecurrenceType.values.map((type) {
            final isSelected = _selectedRecurrence == type;
            return ChoiceChip(
              label: Text(type.description),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedRecurrence = type;
                    _selectedDays = [];
                  });
                }
              },
              selectedColor: ThemeConfig.primaryColor.withOpacity(0.2),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? ThemeConfig.primaryColor : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // 주간 반복 시 요일 선택
        if (_selectedRecurrence == RecurrenceType.weekly) ...[
          const Text(
            '요일 선택',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: DayOfWeek.values.map((day) {
              final isSelected = _selectedDays.contains(day);
              return FilterChip(
                label: Text(day.korean),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(day);
                    } else {
                      _selectedDays.remove(day);
                    }
                  });
                },
                selectedColor: ThemeConfig.primaryColor.withOpacity(0.2),
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? ThemeConfig.primaryColor : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // 날짜 선택
        const Text(
          '시작 날짜',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: ThemeConfig.primaryColor),
                const SizedBox(width: 12),
                Text(
                  '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 시간 선택
        const Text(
          '시간',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: ThemeConfig.primaryColor),
                const SizedBox(width: 12),
                Text(
                  '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Step 3: 추가 옵션
  Widget _buildAdditionalOptionsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '중요도',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            _buildPriorityChip(1, '낮음', Colors.grey),
            _buildPriorityChip(2, '보통', Colors.blue),
            _buildPriorityChip(3, '높음', Colors.orange),
            _buildPriorityChip(4, '긴급', Colors.red),
          ],
        ),
        const SizedBox(height: 24),

        const Text(
          '미리 알림',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildReminderChip(0, '없음'),
            _buildReminderChip(5, '5분 전'),
            _buildReminderChip(10, '10분 전'),
            _buildReminderChip(30, '30분 전'),
            _buildReminderChip(60, '1시간 전'),
          ],
        ),
        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '완료 확인 필요',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '일정 완료 시 확인 버튼을 눌러야 합니다',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _requiresConfirmation,
                onChanged: (value) {
                  setState(() => _requiresConfirmation = value);
                },
                activeColor: ThemeConfig.primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityChip(int priority, String label, Color color) {
    final isSelected = _priority == priority;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _priority = priority);
        }
      },
      selectedColor: color.withOpacity(0.2),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildReminderChip(int minutes, String label) {
    final isSelected = _reminderMinutes == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _reminderMinutes = minutes);
        }
      },
      selectedColor: ThemeConfig.primaryColor.withOpacity(0.2),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? ThemeConfig.primaryColor : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildBottomButtons(bool isEdit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep--),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: ThemeConfig.primaryColor),
                  ),
                  child: const Text(
                    '이전',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _currentStep < 2 ? _nextStep : () => _saveSchedule(isEdit),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeConfig.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _currentStep < 2 ? '다음' : (isEdit ? '수정 완료' : '추가하기'),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) {
      return;
    }

    if (_currentStep == 1) {
      // 주간 반복인데 요일 선택 안 한 경우
      if (_selectedRecurrence == RecurrenceType.weekly && _selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('주간 반복은 요일을 선택해주세요'),
            backgroundColor: ThemeConfig.errorColor,
          ),
        );
        return;
      }
    }

    setState(() => _currentStep++);
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ko', 'KR'),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _saveSchedule(bool isEdit) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = ScheduleRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      scheduleType: _selectedType,
      recurrenceType: _selectedRecurrence,
      executionTime:
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      startDate: _formatDate(_selectedDate),
      endDate: _endDate != null ? _formatDate(_endDate!) : null,
      selectedDays: _selectedRecurrence == RecurrenceType.weekly ? _selectedDays : null,
      dayOfMonth: null,
      intervalValue: 1,
      priority: _priority,
      visualIndicator: null,
      reminderMinutesBefore: _reminderMinutes > 0 ? _reminderMinutes : null,
      requiresConfirmation: _requiresConfirmation,
      isActive: true,
    );

    final provider = context.read<ScheduleProvider>();
    bool success;

    if (isEdit) {
      success = await provider.updateSchedule(widget.editSchedule!.id, request);
    } else {
      success = await provider.createSchedule(request);
    }

    if (mounted) {
      if (success) {
        Navigator.pop(context, true); // 성공 시 true 반환
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? '일정이 수정되었습니다' : '일정이 추가되었습니다'),
            backgroundColor: ThemeConfig.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? '일정 저장에 실패했습니다'),
            backgroundColor: ThemeConfig.errorColor,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
        return ThemeConfig.primaryColor;
      case ScheduleType.therapy:
        return const Color(0xFF9C27B0);
      case ScheduleType.hygiene:
        return const Color(0xFF00BCD4);
      case ScheduleType.safetyCheck:
        return ThemeConfig.errorColor;
      case ScheduleType.socialActivity:
        return const Color(0xFFFF5722);
      case ScheduleType.personalCare:
        return const Color(0xFF795548);
      case ScheduleType.reminder:
        return Colors.grey;
    }
  }
}

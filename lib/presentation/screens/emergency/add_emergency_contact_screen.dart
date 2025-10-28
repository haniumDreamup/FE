import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/services/emergency_contact_service.dart';
import '../../../data/models/emergency_model.dart';

class AddEmergencyContactScreen extends StatefulWidget {
  const AddEmergencyContactScreen({super.key});

  @override
  State<AddEmergencyContactScreen> createState() => _AddEmergencyContactScreenState();
}

class _AddEmergencyContactScreenState extends State<AddEmergencyContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationController = TextEditingController();
  final _emergencyContactService = EmergencyContactService();

  ContactType _contactType = ContactType.family;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 긴급 연락처 생성 요청
      final newContact = EmergencyContactModel(
        id: 0, // 서버에서 생성됨
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        relationship: _relationController.text.trim(),
        contactType: _contactType,
        isActive: true,
        isPrimary: false,
      );

      await _emergencyContactService.createContact(newContact);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // 성공 시 true 반환하고 화면 닫기
        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('긴급 연락처가 추가되었습니다'),
            backgroundColor: TossTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('긴급 연락처 추가 실패: ${e.toString()}'),
            backgroundColor: TossTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('긴급 연락처 추가'),
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
                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '이름',
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: '전화번호',
                    prefixIcon: const Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '전화번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Relation
                TextFormField(
                  controller: _relationController,
                  decoration: InputDecoration(
                    labelText: '관계',
                    hintText: '예: 어머니, 아버지',
                    prefixIcon: const Icon(Icons.people),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '관계를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Contact Type
                DropdownButtonFormField<ContactType>(
                  value: _contactType,
                  decoration: InputDecoration(
                    labelText: '연락처 유형',
                    prefixIcon: const Icon(Icons.category),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: ContactType.values
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Row(
                              children: [
                                Text(type.icon, style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Text(type.description),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _contactType = value!;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveContact,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
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

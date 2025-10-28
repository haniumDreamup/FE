import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/toss_theme.dart';
import '../../../core/utils/error_handler.dart';
import '../../../data/services/emergency_contact_service.dart';
import '../../../data/models/emergency_model.dart';

class EditEmergencyContactScreen extends StatefulWidget {
  final String contactId;

  const EditEmergencyContactScreen({
    super.key,
    required this.contactId,
  });

  @override
  State<EditEmergencyContactScreen> createState() => _EditEmergencyContactScreenState();
}

class _EditEmergencyContactScreenState extends State<EditEmergencyContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationController = TextEditingController();
  final _emergencyContactService = EmergencyContactService();

  ContactType _contactType = ContactType.family;
  bool _isLoading = true;
  EmergencyContactModel? _originalContact;

  @override
  void initState() {
    super.initState();
    _loadContactData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  Future<void> _loadContactData() async {
    try {
      final contact = await _emergencyContactService.getContact(int.parse(widget.contactId));

      if (mounted) {
        setState(() {
          _originalContact = contact;
          _nameController.text = contact.name;
          _phoneController.text = contact.phoneNumber;
          _relationController.text = contact.relationship;
          _contactType = contact.contactType ?? ContactType.family;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('연락처 조회 실패: ${e.toString()}'),
            backgroundColor: TossTheme.errorColor,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedContact = EmergencyContactModel(
        id: _originalContact!.id,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        relationship: _relationController.text.trim(),
        contactType: _contactType,
        isActive: _originalContact!.isActive,
        isPrimary: _originalContact!.isPrimary,
      );

      await _emergencyContactService.updateContact(
        int.parse(widget.contactId),
        updatedContact,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('긴급 연락처가 수정되었습니다'),
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
            content: Text('긴급 연락처 수정 실패: ${e.toString()}'),
            backgroundColor: TossTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _deleteContact() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('연락처 삭제'),
        content: const Text('이 긴급 연락처를 삭제하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _emergencyContactService.deleteContact(int.parse(widget.contactId));

        if (mounted) {
          Navigator.pop(context, true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('긴급 연락처가 삭제되었습니다'),
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
              content: Text('긴급 연락처 삭제 실패: ${e.toString()}'),
              backgroundColor: TossTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('긴급 연락처 수정')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('긴급 연락처 수정'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteContact,
            tooltip: '삭제',
          ),
        ],
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
                    onPressed: _saveContact,
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

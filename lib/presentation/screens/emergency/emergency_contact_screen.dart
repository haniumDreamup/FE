import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/toss_theme.dart';
import '../../../data/models/emergency_model.dart';
import '../../providers/emergency_contact_provider.dart';

/// 긴급 연락처 화면 (BIF 사용자 최적화)
class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});

  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmergencyContactProvider>().loadActiveContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('긴급 연락처'),
        backgroundColor: TossTheme.errorColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<EmergencyContactProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadActiveContacts();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          final contacts = provider.activeContacts;

          if (contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contacts,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '등록된 연락처가 없어요',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadActiveContacts(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 헤더
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: TossTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.phone_in_talk,
                        size: 48,
                        color: TossTheme.errorColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '도움이 필요하면\n아래 번호로 전화하세요',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 연락처 목록
                ...contacts.map((contact) => _ContactCard(
                  contact: contact,
                  onCall: () => _makePhoneCall(contact.phoneNumber),
                  onToggle: () => _toggleContact(contact.id),
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('전화를 걸 수 없어요'),
            backgroundColor: TossTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _toggleContact(int contactId) async {
    final success = await context.read<EmergencyContactProvider>().toggleContactActive(contactId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '연락처 상태가 변경되었어요' : '변경에 실패했어요'),
          backgroundColor: success ? TossTheme.successColor : TossTheme.errorColor,
        ),
      );
    }
  }
}

/// 연락처 카드 (큰 버튼 형태, BIF 사용자 최적화)
class _ContactCard extends StatelessWidget {
  final EmergencyContactModel contact;
  final VoidCallback onCall;
  final VoidCallback onToggle;

  const _ContactCard({
    required this.contact,
    required this.onCall,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onCall,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // 아이콘
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _getTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      contact.categoryIcon,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            contact.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (contact.isPrimary) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '⭐ 주',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        contact.relationship,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 18,
                            color: _getTypeColor(),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            contact.phoneNumber,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _getTypeColor(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 전화 버튼
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: TossTheme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    if (contact.isMedicalProfessional == true) {
      return const Color(0xFFE53935); // 빨강 (의료진)
    }

    if (contact.contactType == null) {
      return Colors.grey;
    }

    switch (contact.contactType!) {
      case ContactType.family:
        return const Color(0xFF43A047); // 초록
      case ContactType.guardian:
        return const Color(0xFF1E88E5); // 파랑
      case ContactType.doctor:
        return const Color(0xFFE53935); // 빨강
      case ContactType.nurse:
        return const Color(0xFFFB8C00); // 주황
      case ContactType.caregiver:
        return const Color(0xFF8E24AA); // 보라
      case ContactType.emergencyService:
        return const Color(0xFFD32F2F); // 진한 빨강
      case ContactType.friend:
        return const Color(0xFF00ACC1); // 청록
      case ContactType.neighbor:
        return const Color(0xFF26A69A); // 청록
      case ContactType.other:
        return Colors.grey;
    }
  }
}

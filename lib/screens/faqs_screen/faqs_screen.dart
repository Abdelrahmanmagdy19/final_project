import 'package:flutter/material.dart';
import 'package:cure_link/utils/app_color.dart';

class FaqItem {
  final String question;
  final String answer;
  bool isOpen;
  FaqItem({required this.question, required this.answer, this.isOpen = false});
}

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> with TickerProviderStateMixin {
  final List<FaqItem> _allFaqs = [
    FaqItem(
      question: 'How do I book an appointment?',
      answer:
          'Open the doctor details, choose a time slot and press "Book". Follow the checkout steps.',
    ),
    FaqItem(
      question: 'How can I cancel my appointment?',
      answer:
          'Go to Schedule, select the appointment and press "Cancel". It will be removed from your schedule.',
    ),
    FaqItem(
      question: 'How do I contact support?',
      answer:
          'Use the contact option in the profile screen or send an email to support@example.com.',
    ),
    FaqItem(
      question: 'How do I update my profile image?',
      answer:
          'Open Profile, tap on the avatar and select an image from your device.',
    ),
    FaqItem(
      question: 'How do I change my password?',
      answer:
          'Go to Profile > Change Password and follow the steps to update your password securely.',
    ),
    FaqItem(
      question: 'How are doctors verified?',
      answer:
          'Doctors are verified through submitted credentials and manual review by our team.',
    ),
    FaqItem(
      question: 'What payment methods are accepted?',
      answer:
          'We accept credit/debit cards and in-app payment gateways configured for your region.',
    ),
    FaqItem(
      question: 'Can I reschedule an appointment?',
      answer:
          'Yes — open the appointment in Schedule and choose reschedule if the option is available.',
    ),
    FaqItem(
      question: 'What is the cancellation policy?',
      answer:
          'Cancellation policies vary by doctor; check the doctor\'s details for specific rules.',
    ),
    FaqItem(
      question: 'How to add a favorite doctor?',
      answer:
          'Open doctor details and tap the favorite icon to add them to your favorites list.',
    ),
    FaqItem(
      question: 'Is there a mobile payment option?',
      answer:
          'Yes, mobile payments are supported where configured. You can add your card in the checkout flow.',
    ),
    FaqItem(
      question: 'How secure is my data?',
      answer:
          'We use industry-standard encryption and follow best practices to keep your data safe.',
    ),
    FaqItem(
      question: 'Can I get reminders for appointments?',
      answer:
          'Yes — enable notifications in app settings to receive reminders before appointments.',
    ),
  ];

  late final List<GlobalKey> _itemKeys;
  List<FaqItem> _filteredFaqs = [];
  String _query = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    _filteredFaqs = List.from(_allFaqs);
    _itemKeys = List.generate(_allFaqs.length, (_) => GlobalKey());
  }

  void _runFilter(String entered) {
    setState(() {
      _query = entered.trim().toLowerCase();
      if (_query.isEmpty) {
        _filteredFaqs = List.from(_allFaqs);
      } else {
        _filteredFaqs = _allFaqs
            .where(
              (f) =>
                  f.question.toLowerCase().contains(_query) ||
                  f.answer.toLowerCase().contains(_query),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Widget _buildFaqCard(FaqItem faq, int index) {
    final originalIndex = _allFaqs.indexOf(faq);
    return Container(
      key: _itemKeys[originalIndex],
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.lightGreenColor, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() => faq.isOpen = !faq.isOpen);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: AppColor.lightGreenColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.help_outline,
                      color: AppColor.greenColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faq.question,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        AnimatedSize(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 300),
                          child: ConstrainedBox(
                            constraints: faq.isOpen
                                ? const BoxConstraints()
                                : const BoxConstraints(maxHeight: 0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                faq.answer,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: faq.isOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: _runFilter,
                decoration: InputDecoration(
                  hintText: 'Search frequently asked questions...',
                  prefixIcon: Icon(Icons.search, color: AppColor.greenColor),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _runFilter('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColor.lightGreenColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filteredFaqs.isEmpty
                  ? Center(
                      child: Text(
                        'No results for $_query',
                        style: const TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      controller: _listController,
                      padding: const EdgeInsets.only(bottom: 24, top: 4),
                      itemCount: _filteredFaqs.length,
                      itemBuilder: (context, index) {
                        final faq = _filteredFaqs[index];
                        return _buildFaqCard(faq, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_bottom.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_page.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _baseUrlController = TextEditingController();
  bool _saving = false;
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKeyController.text = prefs.getString('ai_api_key') ?? '';
    _baseUrlController.text = prefs.getString('ai_base_url') ?? '';
    // Do not auto-open chat — let the user confirm by tapping Save
    setState(() {});
  }

  Future<void> _saveAndShowChat() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_api_key', _apiKeyController.text.trim());
    await prefs.setString('ai_base_url', _baseUrlController.text.trim());
    setState(() {
      _saving = false;
      _showChat = true;
    });
  }

  void _closeChat() {
    setState(() {
      _showChat = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _showChat
            ? ChatPage(embedded: true, onClose: _closeChat)
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add API Key and link to enable AI chat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.greenColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _apiKeyController,
                        hintText: 'Enter the API Key',
                        prefixIcon: const Icon(Icons.vpn_key),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: _baseUrlController,
                        hintText: 'Enter the base URL (e.g. https://...)',
                        prefixIcon: const Icon(Icons.link),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: _saving ? 'Saving...' : 'Save & Open Chat',
                        buttonWidth: double.infinity,
                        buttonHeight: 50,
                        onTap: _saving ? null : _saveAndShowChat,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }
}

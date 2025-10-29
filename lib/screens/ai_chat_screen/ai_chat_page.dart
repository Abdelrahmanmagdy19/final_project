import 'dart:typed_data';

import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/chat_ai_service.dart';
import 'typing_indicator.dart';

class AiChatPage extends StatefulWidget {
  final bool embedded;
  final VoidCallback? onClose;

  const AiChatPage({super.key, this.embedded = false, this.onClose});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final ChatAiService _service = ChatAiService();
  final List<Map<String, dynamic>> _messages = [];

  bool _isTyping = false;
  Uint8List? _selectedImage;
  bool _inputIsArabic = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onInputChanged);
    _captionController.addListener(_onCaptionChanged);
  }

  bool _containsArabic(String s) => RegExp(r'[\u0600-\u06FF]').hasMatch(s);

  void _onInputChanged() {
    final text = _controller.text;
    final isArabic = _containsArabic(text);
    if (isArabic != _inputIsArabic) setState(() => _inputIsArabic = isArabic);
  }

  void _onCaptionChanged() {
    final text = _captionController.text;
    final isArabic = _containsArabic(text);
    if (isArabic != _inputIsArabic) setState(() => _inputIsArabic = isArabic);
  }

  @override
  void dispose() {
    _controller.removeListener(_onInputChanged);
    _captionController.removeListener(_onCaptionChanged);
    _controller.dispose();
    _captionController.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _selectedImage = bytes;
      _captionController.text = '';
    });
    await Future.delayed(const Duration(milliseconds: 120));
    _openImagePreviewInline();
  }

  void _removeSelectedImage() {
    setState(() {
      _selectedImage = null;
      _captionController.clear();
    });
  }

  void _openImagePreviewInline() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage({bool fromPreview = false}) async {
    final rawText = fromPreview
        ? _captionController.text.trim()
        : _controller.text.trim();
    final Uint8List? imageForMessage = _selectedImage;

    if (rawText.isEmpty && imageForMessage == null) return;

    final bool messageIsArabic = _containsArabic(rawText);
    // ensure AI responds in Arabic when user writes Arabic
    final String prompt = messageIsArabic
        ? 'الرجاء الرد باللغة العربية:\n$rawText'
        : rawText;

    // optimistic UI: add user message and remove preview immediately (WhatsApp behavior)
    setState(() {
      _messages.add({
        'text': rawText.isNotEmpty ? rawText : '[Image]',
        'image': imageForMessage,
        'isUser': true,
      });
      _isTyping = true;
      if (fromPreview) {
        _captionController.clear();
      } else {
        _controller.clear();
      }
      _selectedImage = null; // hide preview immediately
      _inputIsArabic = false;
    });

    _scrollToEnd();

    try {
      final reply = await _service.sendMessage(
        prompt,
        imageBytes: imageForMessage,
      );
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add({'text': reply, 'image': null, 'isUser': false});
      });
      _scrollToEnd();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isTyping = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الإرسال')));
    }
  }

  Widget _buildBubble(String? text, bool isUser, [Uint8List? image]) {
    final bool textIsArabic = text != null && _containsArabic(text);
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(6),
      bottomRight: isUser
          ? const Radius.circular(6)
          : const Radius.circular(18),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? AppColor.greenColor : const Color(0xFFF5F6FA),
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (text != null && text.isNotEmpty)
                  Directionality(
                    textDirection: textIsArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Text(
                      text,
                      textAlign: textIsArabic
                          ? TextAlign.right
                          : TextAlign.left,
                      style: TextStyle(
                        fontSize: 15,
                        color: isUser ? Colors.white : Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ),
                if (image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        image,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
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

  Widget _buildTyping() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const TypingIndicator(),
      ),
    ),
  );

  Widget _buildImagePreviewCard() {
    if (_selectedImage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  _selectedImage!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _removeSelectedImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _captionController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(fromPreview: true),
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F6FA),
                    hintText: 'Type a caption...',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppColor.greenColor,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: () => _sendMessage(fromPreview: true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    if (_selectedImage != null) {
      return SafeArea(child: _buildImagePreviewCard());
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.image, color: AppColor.greenColor),
              onPressed: _pickImage,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                textDirection: _inputIsArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                textAlign: _inputIsArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: const Color(0xFFF5F6FA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppColor.greenColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length)
                  return _buildTyping();
                final m = _messages[index];
                return _buildBubble(
                  m['text'] as String?,
                  m['isUser'] as bool,
                  m['image'] as Uint8List?,
                );
              },
            ),
          ),
        ),
        _buildInputArea(),
      ],
    );

    if (widget.embedded) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: content),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: content),
    );
  }
}

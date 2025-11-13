import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cure_link/models/model/health_artilcle_model.dart';
import 'package:cure_link/utils/app_color.dart';

class HealthArticleDetails extends StatefulWidget {
  const HealthArticleDetails({super.key, required this.healthArticleModel});

  final HealthArticleModel healthArticleModel;

  @override
  State<HealthArticleDetails> createState() => _HealthArticleDetailsState();
}

class _HealthArticleDetailsState extends State<HealthArticleDetails> {
  bool _isExpanded = false;
  final int _collapsedLines = 8;

  @override
  Widget build(BuildContext context) {
    final article = widget.healthArticleModel;

    final String content = _cleanContent(
      article.content.isNotEmpty ? article.content : article.description,
    );

    final bool isContentLong = content.length > 200;
    final bool hasFullArticle = article.url.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(article.imageUrl),
            const SizedBox(height: 25),
            _buildTitle(article.title),
            const SizedBox(height: 12),
            _buildAuthorAndDate(article.author, article.publishedAt),
            const SizedBox(height: 25),
            _buildContent(content, isContentLong),
            if (hasFullArticle) ...[
              const SizedBox(height: 10),
              _buildReadFullArticleButton(article.url),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) => AppBar(
    title: const Text(
      'Article Details',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontFamily: 'inter',
      ),
    ),
    centerTitle: true,
  );

  Widget _buildImage(String imageUrl) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.2),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 220,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    ),
  );

  Widget _buildTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      fontFamily: 'inter',
      color: Colors.black,
    ),
  );

  Widget _buildAuthorAndDate(String author, DateTime date) => Row(
    children: [
      const Icon(Icons.person_outline, size: 16, color: Colors.grey),
      const SizedBox(width: 6),
      Text(
        author,
        style: TextStyle(
          fontSize: 14,
          color: AppColor.darkGreyColor2,
          fontFamily: 'inter',
        ),
      ),
      const SizedBox(width: 15),
      const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
      const SizedBox(width: 6),
      Text(
        _formatDate(date),
        style: TextStyle(
          fontSize: 14,
          color: AppColor.darkGreyColor2,
          fontFamily: 'inter',
        ),
      ),
    ],
  );

  Widget _buildContent(String content, bool isContentLong) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AnimatedCrossFade(
        duration: const Duration(milliseconds: 200),
        firstChild: Text(
          content,
          maxLines: _collapsedLines,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
            fontFamily: 'inter',
          ),
        ),
        secondChild: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
            fontFamily: 'inter',
          ),
        ),
        crossFadeState: _isExpanded
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
      ),
      if (isContentLong)
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _isExpanded ? 'Show Less' : 'Read More',
              style: TextStyle(
                color: AppColor.greenColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'inter',
              ),
            ),
          ),
        ),
    ],
  );

  Widget _buildReadFullArticleButton(String url) => Center(
    child: TextButton.icon(
      onPressed: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      icon: const Icon(Icons.open_in_new, color: Colors.blue),
      label: const Text(
        'Read Full Article',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontFamily: 'inter',
        ),
      ),
    ),
  );

  /// ------------------- Helpers -------------------

  String _formatDate(DateTime date) =>
      "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year}";

  String _cleanContent(String content) {
    // إزالة الجزء [+xxxx chars] لو موجود
    final regex = RegExp(r'\[\+\d+\s*chars\]');
    return content.replaceAll(regex, '').trim();
  }
}

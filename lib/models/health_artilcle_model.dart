class HealthArticleModel {
  final String title;
  final String imageUrl;
  final String content;
  final String author;
  final DateTime publishedAt;
  final String url;
  final String description;

  HealthArticleModel({
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.author,
    required this.publishedAt,
    required this.description,
    required this.url,
  });
}

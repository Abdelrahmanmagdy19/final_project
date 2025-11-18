import 'package:cure_link/screens/health_artical_details_screen/health_artical_details.dart';
import 'package:cure_link/services/health_article_services.dart';
import 'package:flutter/material.dart';
import 'package:cure_link/models/model/health_artilcle_model.dart';

class HealthArticleScreen extends StatefulWidget {
  const HealthArticleScreen({super.key});

  @override
  State<HealthArticleScreen> createState() => _HealthArticleScreenState();
}

class _HealthArticleScreenState extends State<HealthArticleScreen> {
  final HealthArticleService _service = HealthArticleService();

  List<HealthArticleModel> articles = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 5;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchArticles();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchArticles({bool refresh = false}) async {
    if (isLoading) return;

    if (refresh) {
      currentPage = 1;
      hasMore = true;
      // المقالات القديمة ستظل موجودة أثناء التحميل لتجنب وميض الشاشة
    }

    setState(() => isLoading = true);

    try {
      final newArticles = await _service.fetchHealthArticles(page: currentPage);

      setState(() {
        if (refresh) {
          articles = newArticles;
        } else {
          articles.addAll(newArticles);
        }

        currentPage++;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  bool hasMore = true;

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMore) {
      fetchArticles();
    }
  }

  Future<void> _refreshArticles() async {
    await fetchArticles(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Health Articles",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshArticles,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: articles.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == articles.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final article = articles[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HealthArticleDetails(healthArticleModel: article),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Image.network(
                        article.imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        errorBuilder: (_, __, ___) =>
                            Container(height: 180, color: Colors.grey[300]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

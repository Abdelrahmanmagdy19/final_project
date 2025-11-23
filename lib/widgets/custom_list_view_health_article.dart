import 'package:cure_link/models/health_artilcle_model.dart';
import 'package:cure_link/services/health_article_services.dart';
import 'package:cure_link/widgets/custom_health_article_home_page.dart';
import 'package:flutter/material.dart';

class CustomListViewHealthArticle extends StatefulWidget {
  const CustomListViewHealthArticle({super.key});

  @override
  State<CustomListViewHealthArticle> createState() =>
      _CustomListViewHealthArticleState();
}

class _CustomListViewHealthArticleState
    extends State<CustomListViewHealthArticle> {
  List<HealthArticleModel> healthArticles = [];
  bool isLoading = false;
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchArticles();
    _scrollController.addListener(_onScroll);
  }

  Future<void> fetchArticles() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      final newArticles = await HealthArticleService().fetchHealthArticles(
        page: currentPage,
      );
      if (!mounted) return; // guard against setState after dispose
      setState(() {
        healthArticles.addAll(newArticles);
        currentPage++;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      fetchArticles();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (healthArticles.isEmpty && isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        controller: _scrollController,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        scrollDirection: Axis.horizontal,
        itemCount: healthArticles.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == healthArticles.length) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomHealthArticleHomePage(
            healthArticleModel: healthArticles[index],
          );
        },
      ),
    );
  }
}

import 'package:cure_link/models/model/health_artilcle_model.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    final articles = await HealthArticleService().fetchHealthArticles();
    setState(() {
      healthArticles = articles;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        scrollDirection: Axis.horizontal,
        itemCount: healthArticles.length,
        itemBuilder: (context, index) {
          return CustomHealthArticleHomePage(
            healthArticleModel: healthArticles[index],
          );
        },
      ),
    );
  }
}

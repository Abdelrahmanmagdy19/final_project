import 'package:cure_link/cubits/favorites_cubits/favorites_cubits_.dart';
import 'package:cure_link/cubits/favorites_cubits/favorites_cubits_state.dart';
import 'package:cure_link/models/health_artilcle_model.dart';
import 'package:cure_link/screens/health_artical_details_screen/health_artical_details.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Articles',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoritesCubits, FavoritesCubitsState>(
        builder: (context, state) {
          if (state is FavoritesCubitsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesCubitsSuccess) {
            final articles = state.articles;

            if (articles.isEmpty) {
              return const Center(
                child: Text(
                  'You haven\'t added any favorite articles yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildArticleTile(context, article),
                );
              },
            );
          }

          return const Center(
            child: Text(
              'Failed to load favorites or an unexpected error occurred.',
              style: TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleTile(BuildContext context, HealthArticleModel article) {
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
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.darkGreyColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Row(
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(article.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width - 168,
                height: 135,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'inter',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      article.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'inter',
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article.author,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'inter',
                          ),
                        ),
                        Text(
                          article.publishedAt.toString().split(' ')[0],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cure_link/cubits/favorites_cubits/favorites_cubits_state.dart';
import 'package:cure_link/models/health_artilcle_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubits extends Cubit<FavoritesCubitsState> {
  final List<HealthArticleModel> _favoriteArticles = [];

  FavoritesCubits() : super(FavoritesCubitsSuccess(articles: const []));

  void addArticleToFavorites(HealthArticleModel article) {
    if (_favoriteArticles.contains(article)) {
      emit(FavoritesCubitsError('Article is already in favorites.'));
      return;
    }

    try {
      _favoriteArticles.add(article);

      emit(FavoritesCubitsSuccess(articles: [..._favoriteArticles]));
    } catch (e) {
      emit(FavoritesCubitsError(e.toString()));
    }
  }

  void removeArticleFromFavorites(HealthArticleModel article) {
    if (_favoriteArticles.remove(article)) {
      emit(FavoritesCubitsSuccess(articles: [..._favoriteArticles]));
    }
  }

  bool isArticleFavorite(HealthArticleModel article) {
    return _favoriteArticles.contains(article);
  }

  List<HealthArticleModel> get favoriteArticles => _favoriteArticles;
}

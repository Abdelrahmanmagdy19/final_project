import 'package:cure_link/models/health_artilcle_model.dart';

class FavoritesCubitsState {}

class FavoritesCubitsLoading extends FavoritesCubitsState {}

class FavoritesCubitsSuccess extends FavoritesCubitsState {
  final List<HealthArticleModel> articles;

  FavoritesCubitsSuccess({required this.articles});
}

class FavoritesCubitsError extends FavoritesCubitsState {
  final String message;

  FavoritesCubitsError(this.message);
}

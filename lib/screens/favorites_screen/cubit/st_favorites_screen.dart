import 'package:gg_copy/models/post_model.dart';

abstract class StFavoritesScreen {
  const StFavoritesScreen();
}

class StFavoritesScreenLoaded extends StFavoritesScreen {
  final List<PostModel> posts;

  StFavoritesScreenLoaded({
    required this.posts,
  });
}

class StFavoritesScreenLoading extends StFavoritesScreen {}

class StFavoritesScreenNoAuthError extends StFavoritesScreen {}

class StFavoritesScreenNoInternetError extends StFavoritesScreen {}

class StFavoritesScreenError extends StFavoritesScreen {
  final int? error;
  final String? message;

  const StFavoritesScreenError({
    this.error,
    this.message,
  });
}

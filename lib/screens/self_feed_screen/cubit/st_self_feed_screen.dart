import 'package:gg_copy/models/post_model.dart';

abstract class StSelfFeedScreen{}

class StSelfFeedScreenInit extends StSelfFeedScreen{}

class StSelfFeedScreenLoaded extends StSelfFeedScreen{
  final List<PostModel> posts;

  StSelfFeedScreenLoaded({required this.posts});
}

class StSelfFeedScreenLoading extends StSelfFeedScreen{}

class StSelfFeedScreenNoAuthError extends StSelfFeedScreen{}

class StSelfFeedScreenNoInternetError extends StSelfFeedScreen {}

class StSelfFeedScreenError extends StSelfFeedScreen{
  final int? error;
  final String? message;
  StSelfFeedScreenError({this.error,this.message});
}
    
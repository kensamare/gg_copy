import 'package:gg_copy/models/post_model.dart';

abstract class StFeedScreen{}

class StFeedScreenInit extends StFeedScreen{}

class StFeedScreenLoaded extends StFeedScreen{
  final List<PostModel> posts;

  StFeedScreenLoaded({required this.posts});
}

class StFeedScreenLoading extends StFeedScreen{}

class StFeedScreenNoAuthError extends StFeedScreen{}

class StFeedScreenNoInternetError extends StFeedScreen {}

class StFeedScreenError extends StFeedScreen{
  final int? error;
  final String? message;
  StFeedScreenError({this.error,this.message});
}
    
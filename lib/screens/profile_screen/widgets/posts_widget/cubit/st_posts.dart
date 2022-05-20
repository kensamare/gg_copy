

import 'package:gg_copy/models/post_model.dart';

abstract class StPosts{}

class StPostsInit extends StPosts{}

class StPostsLoaded extends StPosts{
  List<PostModel> posts = [];
  StPostsLoaded({required this.posts});
}

class StPostsLoading extends StPosts{}

class StPostsNoAuthError extends StPosts{}

class StPostsNoInternetError extends StPosts {}

class StPostsError extends StPosts{
  final int? error;
  final String? message;
  StPostsError({this.error,this.message});
}
    
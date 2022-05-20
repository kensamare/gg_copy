import 'package:gg_copy/models/post_model.dart';

import '../../../models/comment_data_model.dart';

abstract class StCommentFromNotificationsScreen{}

class StCommentFromNotificationsScreenInit extends StCommentFromNotificationsScreen{}

class StCommentFromNotificationsScreenLoaded extends StCommentFromNotificationsScreen{
  final List<CommentDataModel> comments;
  final List<PostModel> postModel;

  StCommentFromNotificationsScreenLoaded({required this.comments, required this.postModel});
}

class StCommentFromNotificationsScreenLoading extends StCommentFromNotificationsScreen{}

class StCommentFromNotificationsScreenNoAuthError extends StCommentFromNotificationsScreen{}

class StCommentFromNotificationsScreenNoInternetError extends StCommentFromNotificationsScreen {}

class StCommentFromNotificationsScreenError extends StCommentFromNotificationsScreen{
  final int? error;
  final String? message;
  StCommentFromNotificationsScreenError({this.error,this.message});
}
    
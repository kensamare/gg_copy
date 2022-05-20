import 'package:gg_copy/models/comment_data_model.dart';

abstract class StCommentScreen{}

class StCommentScreenInit extends StCommentScreen{}

class StCommentScreenLoaded extends StCommentScreen{
  final List<CommentDataModel> comments;

  StCommentScreenLoaded({required this.comments});
}

class StCommentScreenLoading extends StCommentScreen{}

class StCommentScreenNoAuthError extends StCommentScreen{}

class StCommentScreenNoInternetError extends StCommentScreen {}

class StCommentScreenError extends StCommentScreen{
  final int? error;
  final String? message;
  StCommentScreenError({this.error,this.message});
}
    
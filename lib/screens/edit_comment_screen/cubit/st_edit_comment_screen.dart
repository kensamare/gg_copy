abstract class StEditCommentScreen{}

class StEditCommentScreenInit extends StEditCommentScreen{}

class StEditCommentScreenLoaded extends StEditCommentScreen{}

class StEditCommentScreenLoading extends StEditCommentScreen{}

class StEditCommentScreenNoAuthError extends StEditCommentScreen{}

class StEditCommentScreenNoInternetError extends StEditCommentScreen {}

class StEditCommentScreenError extends StEditCommentScreen{
  final int? error;
  final String? message;
  StEditCommentScreenError({this.error,this.message});
}
    
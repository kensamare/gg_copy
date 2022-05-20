import 'package:gg_copy/models/notifications_model.dart';

abstract class StLikesScreen{}

class StLikesScreenInit extends StLikesScreen{}

class StLikesScreenLoaded extends StLikesScreen{
  final List<NotificationsModel> result;
  StLikesScreenLoaded({required this.result});
}

class StLikesScreenLoading extends StLikesScreen{}

class StLikesScreenNoAuthError extends StLikesScreen{}

class StLikesScreenNoInternetError extends StLikesScreen {}

class StLikesScreenError extends StLikesScreen{
  final int? error;
  final String? message;
  StLikesScreenError({this.error,this.message});
}
    
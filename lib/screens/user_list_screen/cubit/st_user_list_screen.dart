import 'package:gg_copy/models/self_model.dart';

abstract class StUserListScreen{}

class StUserListScreenInit extends StUserListScreen{}

class StUserListScreenLoaded extends StUserListScreen{
  List<SelfModel> users;
  StUserListScreenLoaded({required this.users});
}

class StUserListScreenLoading extends StUserListScreen{}

class StUserListScreenNoAuthError extends StUserListScreen{}

class StUserListScreenNoInternetError extends StUserListScreen {}

class StUserListScreenError extends StUserListScreen{
  final int? error;
  final String? message;
  StUserListScreenError({this.error,this.message});
}
    
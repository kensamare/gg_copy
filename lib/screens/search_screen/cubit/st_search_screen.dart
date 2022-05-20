import 'package:gg_copy/models/post_model.dart';

import '../../../models/self_model.dart';

abstract class StSearchScreen{}

class StSearchScreenInit extends StSearchScreen{
  final List<SelfModel> users;
  final List<PostModel> posts;
  StSearchScreenInit({required this.users, required this.posts});
}

class StSearchScreenLoaded extends StSearchScreen{
  final List<SelfModel> users;
  final List<PostModel> posts;
  StSearchScreenLoaded({required this.users, required this.posts});
}

class StSearchScreenLoading extends StSearchScreen{}

class StSearchScreenNoAuthError extends StSearchScreen{}

class StSearchScreenNoInternetError extends StSearchScreen {}

class StSearchScreenError extends StSearchScreen{
  final int? error;
  final String? message;
  StSearchScreenError({this.error,this.message});
}
    
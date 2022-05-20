import 'package:gg_copy/models/post_model.dart';
import '../../../models/self_model.dart';

abstract class StProfileScreen{}

class StProfileScreenInit extends StProfileScreen{}

class StProfileScreenLoaded extends StProfileScreen{
  SelfModel  user;
  List<PostModel> posts;
  final bool isReorderingMode;

  StProfileScreenLoaded({
    required this.user,
    required this.posts,
    this.isReorderingMode = false,
  });
}

class StProfileScreenLoading extends StProfileScreen{}

class StProfileScreenNoAuthError extends StProfileScreen{}

class StProfileScreenNoInternetError extends StProfileScreen {}

class StProfileScreenError extends StProfileScreen{
  final int? error;
  final String? message;
  StProfileScreenError({this.error,this.message});
}
    
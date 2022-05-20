import 'package:gg_copy/models/self_model.dart';

abstract class StLikedScreen{}

class StLikedScreenInit extends StLikedScreen{}

class StLikedScreenLoaded extends StLikedScreen{
  final List<SelfModel> users;

  StLikedScreenLoaded({required this.users});
}

class StLikedScreenLoading extends StLikedScreen{}

class StLikedScreenNoAuthError extends StLikedScreen{}

class StLikedScreenNoInternetError extends StLikedScreen {}

class StLikedScreenError extends StLikedScreen{
  final int? error;
  final String? message;
  StLikedScreenError({this.error,this.message});
}
    
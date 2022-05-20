abstract class StEditProfileScreen{}

class StEditProfileScreenInit extends StEditProfileScreen{
  bool isErrorNickname;
  StEditProfileScreenInit({this.isErrorNickname = false,});
}

class StEditProfileScreenLoaded extends StEditProfileScreen{}

class StEditProfileScreenLoading extends StEditProfileScreen{}

class StEditProfileScreenNoAuthError extends StEditProfileScreen{}

class StEditProfileScreenNoInternetError extends StEditProfileScreen {}

class StEditProfileScreenError extends StEditProfileScreen{
  final int? error;
  final String? message;
  StEditProfileScreenError({this.error,this.message});
}
    
abstract class StSettingScreen{}

class StSettingScreenInit extends StSettingScreen{}

class StSettingScreenLoaded extends StSettingScreen{}

class StSettingScreenLoading extends StSettingScreen{}

class StSettingScreenNoAuthError extends StSettingScreen{}

class StSettingScreenNoInternetError extends StSettingScreen {}

class StSettingScreenError extends StSettingScreen{
  final int? error;
  final String? message;
  StSettingScreenError({this.error,this.message});
}

class StSettingSuccessChange extends StSettingScreen {}
    
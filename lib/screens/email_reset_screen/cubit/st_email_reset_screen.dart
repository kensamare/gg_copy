abstract class StEmailResetScreen{}

class StEmailResetScreenInit extends StEmailResetScreen{}

class StEmailResetScreenLoaded extends StEmailResetScreen{}

class StEmailResetScreenComplete extends StEmailResetScreen{}

class StEmailResetScreenLoading extends StEmailResetScreen{}

class StEmailResetScreenNoAuthError extends StEmailResetScreen{}

class StEmailResetScreenNoInternetError extends StEmailResetScreen {}

class StEmailResetScreenError extends StEmailResetScreen{
  final int? error;
  final String? message;
  StEmailResetScreenError({this.error,this.message});
}
    
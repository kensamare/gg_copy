abstract class StSmsCheckScreen{}

class StSmsCheckScreenInit extends StSmsCheckScreen{}

class StSmsCheckScreenLoaded extends StSmsCheckScreen{}

class StSmsCheckScreenLogin extends StSmsCheckScreen{}

class StSmsCheckScreenLoading extends StSmsCheckScreen{}

class StSmsCheckScreenNoAuthError extends StSmsCheckScreen{}

class StSmsCheckScreenEnterCode extends StSmsCheckScreen{}

class StSmsCheckScreenNoInternetError extends StSmsCheckScreen {}

class StSmsCheckScreenError extends StSmsCheckScreen{
  final int? error;
  final String? message;
  StSmsCheckScreenError({this.error,this.message});
}
    
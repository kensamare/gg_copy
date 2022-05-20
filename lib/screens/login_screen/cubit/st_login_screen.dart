abstract class StLoginScreen{}

class StLoginScreenInit extends StLoginScreen{}

class StLoginScreenLoaded extends StLoginScreen{
  final String? body;
  StLoginScreenLoaded({this.body});
}

class StLoginScreenVerification extends StLoginScreen{
  final String? phone_key;
  StLoginScreenVerification({required this.phone_key});
}

class StLoginScreenLoading extends StLoginScreen{}


class StRegistration extends StLoginScreen{}

class StAuth extends StLoginScreen{}

class StLoginScreenNoAuthError extends StLoginScreen{}

class StLoginScreenNoInternetError extends StLoginScreen {}

class StLoginScreenError extends StLoginScreen{
  final int? error;
  final String? message;
  StLoginScreenError({this.error,this.message});
}
    
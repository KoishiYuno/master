part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class CheckFitbitAccessToken extends HomeEvent {}

class NavigateBaseOnFitbitAccessTokenExists extends HomeEvent {
  final bool exists;

  const NavigateBaseOnFitbitAccessTokenExists(this.exists);

  @override
  List<Object> get props => [exists];
}

class SigninToFitbit extends HomeEvent {
  final BuildContext context;

  const SigninToFitbit(this.context);

  @override
  List<Object> get props => [context];
}

class RequestAccessCredentialsByAuthorizationToken extends HomeEvent {
  final String url;
  final String codeVerifier;

  const RequestAccessCredentialsByAuthorizationToken(
      this.url, this.codeVerifier);

  List<Object> get props => [url, codeVerifier];
}

class UpdateHealthData extends HomeEvent {}

class LinkElderly extends HomeEvent {
  final String code;

  const LinkElderly(this.code);

  @override
  List<Object> get props => [code];
}

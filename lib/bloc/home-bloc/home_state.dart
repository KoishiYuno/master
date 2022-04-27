part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String error;

  const HomeError({required this.error});

  @override
  List<Object> get props => [error];
}

class FitbitAccessTokenLoading extends HomeState {}

class FitbitAccessTokenChecked extends HomeState {
  final bool exsits;

  const FitbitAccessTokenChecked({required this.exsits});

  @override
  List<Object> get props => [exsits];
}

class FitbitAcessTokenExisted extends HomeState {}

class FitbitAcessTokenMissed extends HomeState {}

class FitbitAuthorizationTokenRequsting extends HomeState {}

class FitbitAuthorizationFailed extends HomeState {
  final String error;

  const FitbitAuthorizationFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class HealthDataUpdated extends HomeState {}

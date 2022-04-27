part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LogoutRequested extends AuthEvent {}

class UserChanged extends AuthEvent {
  final User user;

  const UserChanged(this.user);

  @override
  List<Object> get props => [];
}

class HomeNavigationequested extends AuthEvent {}

class ChatNavigationequested extends AuthEvent {}

class ProfileNavigationequested extends AuthEvent {}

class MenuNavigationequested extends AuthEvent {}

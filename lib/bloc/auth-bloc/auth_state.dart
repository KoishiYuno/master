part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, home, profile, chat, menu }

class AuthState extends Equatable {
  final AuthStatus status;
  final User user;

  // Create private constructor
  const AuthState._({
    required this.status,
    this.user = User.empty,
  });

  const AuthState.authenticated(User user)
      : this._(
          status: AuthStatus.authenticated,
          user: user,
        );

  const AuthState.unauthenticated()
      : this._(
          status: AuthStatus.unauthenticated,
          user: User.empty,
        );

  const AuthState.home()
      : this._(
          status: AuthStatus.home,
        );

  const AuthState.profile()
      : this._(
          status: AuthStatus.profile,
        );

  const AuthState.chat()
      : this._(
          status: AuthStatus.chat,
        );

  const AuthState.menu()
      : this._(
          status: AuthStatus.menu,
        );

  @override
  List<Object> get props => [status, user];
}

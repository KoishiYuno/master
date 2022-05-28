part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, home, profile, chat, menu }

class AuthState extends Equatable {
  final AuthStatus status;
  final User user;
  final String targetID;

  // Create private constructor
  const AuthState._({
    required this.status,
    this.user = User.empty,
    this.targetID = '',
  });

  const AuthState.authenticated(User user, String targetID)
      : this._(
          status: AuthStatus.authenticated,
          user: user,
          targetID: targetID,
        );

  const AuthState.unauthenticated()
      : this._(
          status: AuthStatus.unauthenticated,
          user: User.empty,
          targetID: '',
        );

  const AuthState.home(User user, String targetID)
      : this._(
          status: AuthStatus.home,
          user: user,
          targetID: targetID,
        );

  const AuthState.profile(User user, String targetID)
      : this._(
          status: AuthStatus.profile,
          user: user,
          targetID: targetID,
        );

  const AuthState.chat(User user, String targetID)
      : this._(
          status: AuthStatus.chat,
          user: user,
          targetID: targetID,
        );

  const AuthState.menu(User user, String targetID)
      : this._(
          status: AuthStatus.menu,
          user: user,
          targetID: targetID,
        );

  @override
  List<Object> get props => [status, user, targetID];
}

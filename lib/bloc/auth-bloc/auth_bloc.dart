import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master/model/user.dart';
import 'package:master/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User>? _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(
          authRepository.currentUser.isNotEmpty
              ? AuthState.authenticated(authRepository.currentUser)
              : const AuthState.unauthenticated(),
        ) {
    on<UserChanged>(_onUserChanged);
    on<LogoutRequested>(_onLogoutRequested);

    _userSubscription = _authRepository.user.listen(
      (user) => add(UserChanged(user)),
    );
  }

  void _onUserChanged(
    UserChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(
      event.user.isNotEmpty
          ? AuthState.authenticated(event.user)
          : const AuthState.unauthenticated(),
    );
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    unawaited(_authRepository.signOut());
  }

  Future<void> close() async {
    _userSubscription?.cancel();
    return super.close();
  }
}

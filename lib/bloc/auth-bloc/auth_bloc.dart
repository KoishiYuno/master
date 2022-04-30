import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master/model/user.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/data_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final DataRepository _dataRepository;
  StreamSubscription<User>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required DataRepository dataRepository,
  })  : _authRepository = authRepository,
        _dataRepository = dataRepository,
        super(
          authRepository.currentUser.isNotEmpty
              ? AuthState.authenticated(authRepository.currentUser)
              : const AuthState.unauthenticated(),
        ) {
    on<UserChanged>(_onUserChanged);
    on<LogoutRequested>(_onLogoutRequested);
    on<HomeNavigationequested>(_onHomeNavigationequested);
    on<ChatNavigationequested>(_onChatNavigationequested);
    on<ProfileNavigationequested>(_onProfileNavigationequested);
    on<MenuNavigationequested>(_onMenuNavigationequested);

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
    unawaited(_dataRepository.removeRegistrationToken(
        userid: _authRepository.currentUser.id));
    unawaited(_authRepository.signOut());
  }

  _onHomeNavigationequested(
    HomeNavigationequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.home());
  }

  _onChatNavigationequested(
    ChatNavigationequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.chat());
  }

  _onProfileNavigationequested(
    ProfileNavigationequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.profile());
  }

  _onMenuNavigationequested(
    MenuNavigationequested event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.menu());
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    return super.close();
  }
}

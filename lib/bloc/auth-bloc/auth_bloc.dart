import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master/model/user.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/home_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final HomeRepository _homeRepository;
  final String targetID;
  StreamSubscription<User>? _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required HomeRepository homeRepository,
    required this.targetID,
  })  : _authRepository = authRepository,
        _homeRepository = homeRepository,
        super(
          authRepository.currentUser.isNotEmpty
              ? AuthState.authenticated(authRepository.currentUser, targetID)
              : const AuthState.unauthenticated(),
        ) {
    on<UserChanged>(_onUserChanged);
    on<LogoutRequested>(_onLogoutRequested);
    on<TargetIdUpdated>(_onTargetIdUpdated);
    on<HomeNavigationequested>(_onHomeNavigationequested);
    on<ChatNavigationequested>(_onChatNavigationequested);
    on<ProfileNavigationequested>(_onProfileNavigationequested);
    on<MenuNavigationequested>(_onMenuNavigationequested);

    _userSubscription = _authRepository.user.listen(
      (user) => add(UserChanged(user)),
    );
  }

  Future<void> _onUserChanged(
    UserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user.isNotEmpty) {
      final response =
          await _homeRepository.getElderlyDetail(userid: event.user.id);

      final data = response.data();

      print(data);

      if (data!['userType'] == 'Elderly') {
        emit(AuthState.authenticated(event.user, event.user.id));
      } else {
        var id = ' ';
        if (data.containsKey('elderly')) {
          id = data['elderly'];
        }
        emit(AuthState.authenticated(event.user, id));
      }
    } else {
      emit(const AuthState.unauthenticated());
    }

    // emit(
    //   event.user.isNotEmpty
    //       ? AuthState.authenticated(event.user, '')
    //       : const AuthState.unauthenticated(),
    // );
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    unawaited(_homeRepository.removeRegistrationToken(
        userid: _authRepository.currentUser.id));
    unawaited(_authRepository.signOut());
  }

  Future<void> _onTargetIdUpdated(
    TargetIdUpdated event,
    Emitter<AuthState> emit,
  ) async {
    print('state is' + state.toString());
    final response =
        await _homeRepository.getElderlyDetail(userid: state.user.id);

    final data = response.data();

    if (data!['userType'] == 'Elderly') {
      print('data is ' + state.user.id);
      emit(AuthState.authenticated(state.user, state.user.id));
    } else {
      emit(AuthState.authenticated(state.user, data['elderly']));
    }
  }

  void _onHomeNavigationequested(
    HomeNavigationequested event,
    Emitter<AuthState> emit,
  ) {
    emit(
      AuthState.home(
        state.user,
        state.targetID,
      ),
    );
  }

  void _onChatNavigationequested(
    ChatNavigationequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthState.chat(
      state.user,
      state.targetID,
    ));
  }

  void _onProfileNavigationequested(
    ProfileNavigationequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthState.profile(
      state.user,
      state.targetID,
    ));
  }

  void _onMenuNavigationequested(
    MenuNavigationequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthState.menu(
      state.user,
      state.targetID,
    ));
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    return super.close();
  }
}

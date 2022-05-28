import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/home_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  var _isDisposed = false;

  LoginCubit(
    this._authRepository,
  ) : super(LoginState.initial());

  void emailChanged(String email) {
    emit(state.copywith(
      email: email,
      status: LoginStatus.initial,
    ));
  }

  void passwordChanged(String password) {
    emit(state.copywith(
      password: password,
      status: LoginStatus.initial,
    ));
  }

  Future<void> loginWithCredentials() async {
    if (_isDisposed) return;
    if (state.status == LoginStatus.submitting) return;
    emit(state.copywith(status: LoginStatus.submitting));

    try {
      await _authRepository.logInWithEmailAndPassword(
          email: state.email, password: state.password);

      if (_authRepository.currentUser.isNotEmpty) {
        await _authRepository.addRegistrationToken(
            userid: _authRepository.currentUser.id);
      }

      // emit(state.copywith(status: LoginStatus.success));
    } catch (e) {
      if (!_isDisposed) {
        emit(state.copywith(
          error: e.toString(),
          status: LoginStatus.error,
        ));
      }
    }
  }

  Future<void> loginWithGoogle() async {
    if (state.status == LoginStatus.submitting) return;
    emit(state.copywith(status: LoginStatus.submitting));

    try {
      await _authRepository.signInWithGoogle();
      emit(state.copywith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copywith(
        error: e.toString(),
        status: LoginStatus.error,
      ));
    }
  }

  void dispose() {
    _isDisposed = true;
  }
}

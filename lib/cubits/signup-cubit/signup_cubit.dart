import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/data_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;
  SignupCubit(this._authRepository, this._dataRepository)
      : super(SignupState.initial());

  void emailChanged(String email) {
    emit(state.copywith(
      email: email,
      status: SignupStatus.initial,
    ));
  }

  void passwordChanged(String password) {
    emit(state.copywith(
      password: password,
      status: SignupStatus.initial,
    ));
  }

  void usernameChanged(String username) {
    emit(state.copywith(
      username: username,
      status: SignupStatus.initial,
    ));
  }

  void userTypeChanged(String userType) {
    emit(state.copywith(
      userType: userType,
      status: SignupStatus.initial,
    ));
    print('state emitted ' + userType);
    print('state now is ' + state.userType);
  }

  Future<void> signupFormSubmitted() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copywith(status: SignupStatus.submitting));
    try {
      await _authRepository
          .signUp(email: state.email, password: state.password)
          .then((value) => null);

      await _dataRepository.createNewUser(
          id: _authRepository.currentUser.id,
          username: state.username,
          userType: state.userType);

      emit(state.copywith(status: SignupStatus.success));
    } catch (e) {
      emit(state.copywith(
        error: e.toString(),
        status: SignupStatus.error,
      ));
    }
  }
}

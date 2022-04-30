import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/auth_repository.dart';
import '../../repository/data_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;

  ProfileCubit(
    this._dataRepository,
    this._authRepository,
  ) : super(ProfileState.initial());

  void setIntial(Map<String, dynamic> data) {
    print(111111);
    emit(state.copywith(
      username: data.containsKey('username') ? data['username'] : '',
      height: data.containsKey('height') ? data['height'] : '',
      weight: data.containsKey('weight') ? data['weight'] : '',
      age: data.containsKey('age') ? data['age'] : '',
      status: ProfileStatus.initial,
    ));
  }

  void usernameChanged(String username) {
    emit(state.copywith(
      username: username,
      status: ProfileStatus.initial,
    ));
  }

  void heightChanged(String height) {
    emit(state.copywith(
      height: height,
      status: ProfileStatus.initial,
    ));
  }

  void weightChanged(String weight) {
    print('weight is ' + weight);
    emit(state.copywith(
      weight: weight,
      status: ProfileStatus.initial,
    ));
  }

  void ageChanged(String age) {
    emit(state.copywith(
      age: age,
      status: ProfileStatus.initial,
    ));
  }

  Future<void> updateProfile() async {
    if (state.status == ProfileStatus.submitting) return;
    emit(state.copywith(status: ProfileStatus.submitting));

    try {
      print(state);
      _dataRepository.updateProfile(
          id: _authRepository.currentUser.id,
          username: state.username,
          height: state.height,
          weight: state.weight,
          age: state.age);
    } catch (e) {
      emit(state.copywith(
        error: e.toString(),
        status: ProfileStatus.error,
      ));
    }
    emit(state.copywith(status: ProfileStatus.success));
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/auth_repository.dart';
import '../../repository/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final AuthRepository _authRepository;

  ProfileCubit(
    this._profileRepository,
    this._authRepository,
  ) : super(ProfileState.initial());

  void setIntial(Map<String, dynamic> data) {
    emit(state.copywith(
      duration: data.containsKey('duration') ? data['duration'] : '',
      height: data.containsKey('height') ? data['height'] : '',
      weight: data.containsKey('weight') ? data['weight'] : '',
      age: data.containsKey('age') ? data['age'] : '',
      status: ProfileStatus.initial,
    ));
  }

  void durationChanged(String duration) {
    emit(state.copywith(
      duration: duration,
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
      _profileRepository.updateProfile(
          id: _authRepository.currentUser.id,
          duration: state.duration,
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

part of 'profile_cubit.dart';

enum ProfileStatus { initial, submitting, success, error }

class ProfileState extends Equatable {
  final String username;
  final String weight;
  final String height;
  final String age;
  final ProfileStatus status;
  final String error;

  const ProfileState({
    required this.weight,
    required this.error,
    required this.status,
    required this.height,
    required this.username,
    required this.age,
  });

  factory ProfileState.initial() {
    print('initial');
    return const ProfileState(
      username: '',
      weight: '',
      error: '',
      age: '',
      height: '',
      status: ProfileStatus.initial,
    );
  }

  @override
  List<Object> get props => [username, height, weight, status, age, error];

  ProfileState copywith({
    String? height,
    String? error,
    String? weight,
    String? username,
    String? age,
    ProfileStatus? status,
  }) {
    return ProfileState(
      height: height ?? this.height,
      error: error ?? this.error,
      status: status ?? this.status,
      weight: weight ?? this.weight,
      username: username ?? this.username,
      age: age ?? this.age,
    );
  }
}

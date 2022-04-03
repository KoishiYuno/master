part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

class SignupState extends Equatable {
  final String email;
  final String password;
  final String username;
  final String userType;
  final String error;
  final SignupStatus status;

  const SignupState({
    required this.email,
    required this.password,
    required this.username,
    required this.userType,
    required this.error,
    required this.status,
  });

  factory SignupState.initial() {
    return const SignupState(
      email: '',
      password: '',
      username: '',
      userType: '',
      error: '',
      status: SignupStatus.initial,
    );
  }

  SignupState copywith({
    String? email,
    String? password,
    String? username,
    String? userType,
    String? error,
    SignupStatus? status,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      userType: userType ?? this.userType,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props =>
      [email, password, username, userType, error, status];
}

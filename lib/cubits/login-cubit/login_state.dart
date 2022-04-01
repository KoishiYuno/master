part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final String error;
  final LoginStatus status;

  const LoginState({
    required this.email,
    required this.password,
    required this.error,
    required this.status,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      error: '',
      status: LoginStatus.initial,
    );
  }

  @override
  List<Object> get props => [email, password, status];

  LoginState copywith({
    String? email,
    String? password,
    String? error,
    LoginStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}

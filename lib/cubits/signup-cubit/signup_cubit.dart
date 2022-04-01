import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master/repository/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupInitial());
}

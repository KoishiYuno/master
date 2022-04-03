// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/repository/data_repository.dart';

import '../cubits/signup-cubit/signup_cubit.dart';
import '../repository/auth_repository.dart';
import '../widgets/signup-widgets/view.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignupScreen());
  }

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider<SignupCubit>(
          create: (_) => SignupCubit(
              context.read<AuthRepository>(), context.read<DataRepository>()),
          child: BlocListener<SignupCubit, SignupState>(
            listener: (context, state) {
              if (state.status == SignupStatus.error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              } else if (state.status == SignupStatus.success) {
                Navigator.pop(context);
              }
            },
            child: _SignupForm(signupFormKey: _signupFormKey),
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  final GlobalKey<FormState> _signupFormKey;

  const _SignupForm({required GlobalKey<FormState> signupFormKey, Key? key})
      : _signupFormKey = signupFormKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signupFormKey,
      child: Align(
        alignment: const Alignment(0, -1 / 1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                height: 120,
              ),
              const SizedBox(height: 20),
              EmailInput(),
              const SizedBox(height: 8),
              PasswordInput(),
              const SizedBox(height: 8),
              UsernameInput(),
              const SizedBox(height: 8),
              UserTypeInput(),
              const SizedBox(height: 8),
              SignupButton(
                signupFormKey: _signupFormKey,
              ),
              const SizedBox(height: 8),
              BackToLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

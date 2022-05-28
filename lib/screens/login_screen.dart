import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/cubits/login-cubit/login_cubit.dart';
import 'package:master/repository/auth_repository.dart';

import '../widgets/login-widgets/view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginScreen());

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginScreen());
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(
            context.read<AuthRepository>(),
          ),
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            child: _LoginForm(formKey: _formKey),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  const _LoginForm({required GlobalKey<FormState> formKey, Key? key})
      : _formKey = formKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Align(
        alignment: const Alignment(0, -0.5 / 2),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                height: 120,
              ),
              const SizedBox(height: 30),
              const EmailInput(),
              const SizedBox(height: 8),
              const PasswordInput(),
              const SizedBox(height: 40),
              LoginButton(
                formKey: _formKey,
              ),
              // const SizedBox(height: 8),
              // const GoogleLoginButton(),
              const SizedBox(height: 8),
              const SignupButton(),
            ],
          ),
        ),
      ),
    );
  }
}

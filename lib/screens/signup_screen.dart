import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/bloc/auth-bloc/auth_bloc.dart';

import '../cubits/signup-cubit/signup_cubit.dart';
import '../repository/auth_repository.dart';

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
          create: (_) => SignupCubit(context.read<AuthRepository>()),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _EmailInput(),
          const SizedBox(height: 8),
          _PasswordInput(),
          const SizedBox(height: 8),
          _SignupButton(
            signupFormKey: _signupFormKey,
          ),
          const SizedBox(height: 8),
          // _LoginButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Email address cannot be empty.';
            } else if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) {
              return 'Please enter a valid email address.';
            } else {
              return null;
            }
          },
          onChanged: (email) {
            context.read<SignupCubit>().emailChanged(email);
          },
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'Please re-enter your password';
            } else if (value.toString().length < 6) {
              return 'Password must be at least 6 digits';
            } else {
              return null;
            }
          },
          onChanged: (password) {
            context.read<SignupCubit>().passwordChanged(password);
          },
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  final GlobalKey<FormState> _signupFormKey;

  const _SignupButton({Key? key, required GlobalKey<FormState> signupFormKey})
      : _signupFormKey = signupFormKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignupStatus.submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 40),
                ),
                onPressed: () {
                  final isValid = _signupFormKey.currentState!.validate();
                  if (isValid) {
                    context.read<SignupCubit>().signupFormSubmitted();
                  }
                },
                child: const Text('Signup'),
              );
      },
    );
  }
}

// class _LoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         primary: Colors.white,
//         fixedSize: const Size(200, 40),
//       ),
//       onPressed: () => Navigator.of(context).push<void>(LoginScreen.route()),
//       child: const Text(
//         'Login',
//         style: TextStyle(color: Colors.blue),
//       ),
//     );
//   }
// }

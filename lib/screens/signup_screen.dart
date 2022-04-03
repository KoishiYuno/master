// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/repository/data_repository.dart';

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
              _EmailInput(),
              const SizedBox(height: 8),
              _PasswordInput(),
              const SizedBox(height: 8),
              _UsernameInput(),
              const SizedBox(height: 8),
              _UserTypeInput(),
              const SizedBox(height: 8),
              _SignupButton(
                signupFormKey: _signupFormKey,
              ),
              const SizedBox(height: 8),
              _BackToLoginButton(),
            ],
          ),
        ),
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
            labelText: "Email",
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
            labelText: "Password",
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

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(
            labelText: "Username",
            border: OutlineInputBorder(),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value.toString().isEmpty) {
              return 'Username cannot be empty.';
            } else if (!RegExp(r'^[a-z]+$')
                .hasMatch(value.toString().toLowerCase())) {
              return 'A valid username can only contains alphabets';
            } else {
              return null;
            }
          },
          onChanged: (username) {
            context.read<SignupCubit>().usernameChanged(username);
          },
        );
      },
    );
  }
}

class _UserTypeInput extends StatefulWidget {
  @override
  State<_UserTypeInput> createState() => _UserTypeInputState();
}

class _UserTypeInputState extends State<_UserTypeInput> {
  final List<String> _userTypes = ['Elderly', 'Dependant', 'Caregivers'];
  var _selectedUserType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          validator: (value) => value == null ? 'Field required' : null,
          isExpanded: true,
          hint: const Text("Please Choose A User Type"),
          value: _selectedUserType,
          items: _userTypes.map((String userType) {
            return DropdownMenuItem<String>(
              child: Text(userType),
              value: userType,
            );
          }).toList(),
          onChanged: (userType) {
            setState(() {
              _selectedUserType = userType;
              context
                  .read<SignupCubit>()
                  .userTypeChanged(_selectedUserType.toString());
            });
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  fixedSize: const Size(120, 40),
                  primary: const Color.fromARGB(255, 76, 0, 255),
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

class _BackToLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        'Already Have An Account? Sign Up',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}

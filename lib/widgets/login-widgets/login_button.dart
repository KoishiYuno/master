import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/login-cubit/login_cubit.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> _formKey;

  const LoginButton({Key? key, required GlobalKey<FormState> formKey})
      : _formKey = formKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == LoginStatus.submitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: const Color.fromARGB(255, 76, 0, 255),
                  fixedSize: const Size(120, 40),
                ),
                onPressed: () {
                  final isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    context.read<LoginCubit>().loginWithCredentials();
                  }
                },
                child: const Text('Login'),
              );
      },
    );
  }
}

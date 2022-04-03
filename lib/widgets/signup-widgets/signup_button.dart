import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/signup-cubit/signup_cubit.dart';

class SignupButton extends StatelessWidget {
  final GlobalKey<FormState> _signupFormKey;

  const SignupButton({Key? key, required GlobalKey<FormState> signupFormKey})
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/signup-cubit/signup_cubit.dart';

class UsernameInput extends StatelessWidget {
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

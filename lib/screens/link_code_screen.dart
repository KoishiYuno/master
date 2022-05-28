import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/link=code-cubit/link_code_cubit.dart';
import '../repository/auth_repository.dart';
import '../repository/link_code_repository.dart';

class LinkCodeScreen extends StatelessWidget {
  const LinkCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LinkCodeCubit(
        context.read<LinkCodeRepository>(),
        context.read<AuthRepository>(),
      ),
      child: BlocBuilder<LinkCodeCubit, LinkCodeState>(
        builder: (context, state) {
          if (state.status == LinkCodeStatus.success) {
            return Scaffold(
              body: Center(
                child: Column(children: <Widget>[
                  const SizedBox(
                    height: 180,
                  ),
                  const Text(
                    'Your Link Code is: ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    state.code,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 30,
                      color: Color.fromARGB(255, 0, 73, 133),
                    ),
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Confirm')),
                ]),
              ),
            );
          } else {
            context.read<LinkCodeCubit>().generateLinkCode();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

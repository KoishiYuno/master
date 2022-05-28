import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/bloc/home-bloc/home_bloc.dart';
import 'package:master/cubits/link-elderly-cubit/link_elderly_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../bloc/auth-bloc/auth_bloc.dart';
import '../../repository/auth_repository.dart';
import '../../repository/home_repository.dart';

class LinkElderlyAccount extends StatelessWidget {
  LinkElderlyAccount({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LinkElderlyCubit(
        context.read<HomeRepository>(),
        context.read<AuthRepository>(),
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return BlocListener<LinkElderlyCubit, LinkElderlyState>(
            listener: (context, state) {
              if (state.status == LinkElderlyStatus.error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
              if (state.status == LinkElderlyStatus.success) {
                context.read<AuthBloc>().add(TargetIdUpdated());
                context.read<HomeBloc>().emit(ElderlyAccountLinked());
              }
            },
            child: BlocBuilder<LinkElderlyCubit, LinkElderlyState>(
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Link Elderly Account'),
                    automaticallyImplyLeading: false,
                    actions: <Widget>[
                      IconButton(
                        key: const Key('homePage_logout_iconButton'),
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: () =>
                            context.read<AuthBloc>().add(LogoutRequested()),
                      )
                    ],
                  ),
                  body: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        const Center(child: Text('Please enter the link code')),
                        const Center(
                            child: Text(
                                'You can obtain the link code from your elderly\'s app')),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 30),
                            child: PinCodeTextField(
                              appContext: context,
                              animationType: AnimationType.fade,
                              pastedTextStyle: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.bold,
                              ),
                              validator: (v) {
                                if (v!.length < 6) {
                                  return "Please Enter A Valid Code";
                                } else {
                                  return null;
                                }
                              },
                              length: 6,
                              onChanged: (String code) {
                                context
                                    .read<LinkElderlyCubit>()
                                    .codeChanged(code);
                              },
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            print(state.code);
                            formKey.currentState!.validate();
                            if (state.code.length == 6) {
                              print('Validated');
                              context.read<LinkElderlyCubit>().linkElderly();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fixedSize: const Size(120, 40),
                          ),
                          child: const Text(
                            "VERIFY",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

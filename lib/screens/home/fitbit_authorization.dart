import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../../bloc/auth-bloc/auth_bloc.dart';
import '../../bloc/home-bloc/home_bloc.dart';

class FitbitAuthorization extends StatefulWidget {
  const FitbitAuthorization({Key? key}) : super(key: key);

  @override
  State<FitbitAuthorization> createState() => _FitbitAuthorizationState();
}

class _FitbitAuthorizationState extends State<FitbitAuthorization> {
  bool webView = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Login to Fitbit'),
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
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is FitbitAuthorizationFailed) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: const Alignment(0, -1 / 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/fitbit.png',
                          height: 200,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          'Fitbit',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          width: 300,
                          child: Text(
                            'Please sign in to your Fitbit account to allow us to access your health data. We will store your data securely and your data will not be shared with any third-party organizations without your permission',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              context
                                  .read<HomeBloc>()
                                  .add(SigninToFitbit(context));
                              setState(() {
                                webView = true;
                              });
                            },
                            child: const Text("Signin To Your Fitbit Account")),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Builder(builder: (context) {
            final flutterWebViewPlugin = FlutterWebviewPlugin();
            if (webView == true) {
              return BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        flutterWebViewPlugin.goBack();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        flutterWebViewPlugin.goForward();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.autorenew),
                      onPressed: () {
                        flutterWebViewPlugin.reload();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        flutterWebViewPlugin.close();
                        setState(() {
                          webView = false;
                        });
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox(
                height: 0,
              );
            }
          }),
        );
      },
    );
  }
}

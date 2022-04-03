import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/bloc/auth-bloc/auth_bloc.dart';
import 'package:master/config/theme.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/repository/data_repository.dart';

import 'config/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final AuthRepository authRepository = AuthRepository();
  final DataRepository dataRepository = DataRepository();
  runApp(MyApp(
    authRepository: authRepository,
    dataRepository: dataRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository;
  final DataRepository _dataRepository;
  const MyApp({
    Key? key,
    required DataRepository dataRepository,
    required AuthRepository authRepository,
  })  : _dataRepository = dataRepository,
        _authRepository = authRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: RepositoryProvider.value(
        value: _dataRepository,
        child: BlocProvider(
          create: (_) => AuthBloc(authRepository: _authRepository),
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: FlowBuilder(
          state: context.select((AuthBloc bloc) => bloc.state.status),
          onGeneratePages: onGenerateAppViewPages),
    );
  }
}

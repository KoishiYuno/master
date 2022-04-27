import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/bloc/home-bloc/home_bloc.dart';
import 'package:master/repository/data_repository.dart';
import 'package:master/repository/fitbit_repository.dart';
import 'package:master/screens/home/fitbit_authorization.dart';
import 'package:master/screens/home/home_main.dart';

import '../repository/auth_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  static Page page() => const MaterialPage<void>(child: HomeScreen());

  static Route route() {
    return MaterialPageRoute<void>(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        authRepository: context.read<AuthRepository>(),
        dataRepository: context.read<DataRepository>(),
        fitbitRepository: context.read<FitbitRepository>(),
      )..add(CheckFitbitAccessToken()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is FitbitAcessTokenExisted ||
              state is FitbitAuthorizationFailed ||
              state is HealthDataUpdated) {
            return const HomeMainPage();
          } else if (state is FitbitAcessTokenMissed) {
            return const FitbitAuthorization();
          } else if (state is HomeError) {
            return Text(state.error);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

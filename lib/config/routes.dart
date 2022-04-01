import 'package:flutter/material.dart';
import 'package:master/bloc/auth-bloc/auth_bloc.dart';
import 'package:master/screens/home_screen.dart';
import 'package:master/screens/login_screen.dart';

List<Page> onGenerateAppViewPages(
  AuthStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AuthStatus.authenticated:
      return [HomeScreen.page()];
    case AuthStatus.unauthenticated:
      return [LoginScreen.page()];
  }
}

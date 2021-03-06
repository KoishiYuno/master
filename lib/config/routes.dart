import 'package:flutter/material.dart';
import 'package:master/bloc/auth-bloc/auth_bloc.dart';
import 'package:master/screens/chat_screen.dart';
import 'package:master/screens/home/home_screen.dart';
import 'package:master/screens/login_screen.dart';
import 'package:master/screens/profile_screen.dart';

import '../screens/menu_screen.dart';

List<Page> onGenerateAppViewPages(
  // NavigationStatus navState,
  AuthStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AuthStatus.authenticated:
      return [HomeScreen.page()];
    case AuthStatus.unauthenticated:
      return [LoginScreen.page()];
    case AuthStatus.home:
      return [HomeScreen.page()];
    case AuthStatus.profile:
      return [ProfileScreen.page()];
    case AuthStatus.chat:
      return [ChatScreen.page()];
    case AuthStatus.menu:
      return [MenuScreen.page()];
  }
}

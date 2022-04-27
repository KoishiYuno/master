// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth-bloc/auth_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return BottomAppBar(
          color: Colors.white,
          child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: 'Home',
                    icon: Icon(Icons.home),
                    onPressed: () {
                      context.read<AuthBloc>().add(HomeNavigationequested());
                    },
                  ),
                  IconButton(
                    tooltip: 'Profile',
                    icon: Icon(Icons.person),
                    onPressed: () {
                      context.read<AuthBloc>().add(ProfileNavigationequested());
                    },
                  ),
                  IconButton(
                    tooltip: 'Chat',
                    icon: Icon(Icons.chat),
                    onPressed: () {
                      context.read<AuthBloc>().add(ChatNavigationequested());
                    },
                  ),
                  IconButton(
                    tooltip: 'Menu',
                    icon: Icon(Icons.view_list),
                    onPressed: () {
                      context.read<AuthBloc>().add(MenuNavigationequested());
                    },
                  ),
                ],
              )),
        );
      },
    );
  }
}

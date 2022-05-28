import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/screens/link_code_screen.dart';

import '../bloc/auth-bloc/auth_bloc.dart';
import '../widgets/bottom_nav_bar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: MenuScreen());

  @override
  Widget build(BuildContext context) {
    print(context.read<AuthBloc>().targetID);
    print(context.read<AuthRepository>().currentUser.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: ListView(
        children: <Widget>[
          if (context.read<AuthBloc>().state.targetID ==
              context.read<AuthRepository>().currentUser.id)
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LinkCodeScreen(),
                    ),
                  );
                },
                child: const ListTile(
                  title: Text('Generate Link Code'),
                ),
              ),
            ),
          Card(
            child: InkWell(
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
              child: const ListTile(
                title: Text('Sign Out'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

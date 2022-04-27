import 'package:flutter/material.dart';
import 'package:master/widgets/bottom_nav_bar.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SplashScreen());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Not implemented yet"),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

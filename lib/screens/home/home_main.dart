import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:master/widgets/bottom_nav_bar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../bloc/auth-bloc/auth_bloc.dart';
import '../../widgets/home-widgets/view.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({Key? key}) : super(key: key);

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  final f = DateFormat('dd-MM-yyyy');
  final current = DateTime.now();

  String date = '';

  @override
  void initState() {
    date = f.format(current).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(context.read<AuthBloc>().state.targetID);
    print(date);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        automaticallyImplyLeading: false,
        // actions: <Widget>[
        //   IconButton(
        //     key: const Key('homePage_logout_iconButton'),
        //     icon: const Icon(Icons.exit_to_app),
        //     onPressed: () => context.read<AuthBloc>().add(LogoutRequested()),
        //   )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Image.asset(
              'assets/heartBeat.png',
              height: MediaQuery.of(context).size.height * 0.23,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: HeartRateDetail(
                date: date,
                current: current,
              ),
            ),
            HeartRateDiagram(
              date: date,
              current: current,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              child: SfDateRangePicker(
                initialSelectedDate: current,
                maxDate: current,
                selectionMode: DateRangePickerSelectionMode.single,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  setState(() {
                    date = f.format(args.value).toString();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

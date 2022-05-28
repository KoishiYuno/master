import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth-bloc/auth_bloc.dart';
import 'draw_plot.dart';

class HeartRateDiagram extends StatelessWidget {
  final String date;
  final DateTime current;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  HeartRateDiagram({
    Key? key,
    required this.date,
    required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firebaseFirestore
            .collection('users')
            .doc(context.read<AuthBloc>().state.targetID)
            .collection('healthData')
            .doc(date)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data.data();
            if (data == null) {
              return const Center();
            } else {
              return DrawPlot(
                data: data,
                date: date,
              );
            }
          } else {
            return Container();
          }
        });
  }
}

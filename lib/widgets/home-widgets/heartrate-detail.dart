import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/main.dart';

import '../../bloc/auth-bloc/auth_bloc.dart';

class HeartRateDetail extends StatelessWidget {
  final String date;
  final DateTime current;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  HeartRateDetail({
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
              return const Center(
                  child: Text('No Heart Rate Records Avaliable'));
            } else {
              var heartRates = <int>[];

              for (var record in data['heart_rate']) {
                if (record['value'] != null) {
                  heartRates.add(record['value']);
                }
              }

              print(data['heart_rate'][data['heart_rate'].length - 1]);

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: 42.0,
                          color: const Color.fromARGB(255, 45, 82, 124),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Average Heart Rate',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(211, 255, 255, 255),
                                ),
                              ),
                              Text(
                                '${heartRates.reduce((a, b) => a + b) ~/ heartRates.length}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 234, 234, 188),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: 42.0,
                          color: const Color.fromARGB(255, 206, 232, 250),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Most Recent Record',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 52, 52, 52),
                                ),
                              ),
                              Text(
                                '${heartRates.last}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 90, 72, 229),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 27),
                              ),
                              if (data['heart_rate']
                                      [data['heart_rate'].length - 1]['time'] ==
                                  'predict')
                                const Text(
                                  '(Predict Value)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 52, 52, 52),
                                  ),
                                ),
                            ],
                          ),
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  )
                ],
              );
              // return DrawPlot(
              //   data: data,
              //   date: date,
              // );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

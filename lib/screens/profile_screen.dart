import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/bloc/auth-bloc/auth_bloc.dart';
import 'package:master/repository/auth_repository.dart';
import 'package:master/widgets/bottom_nav_bar.dart';

import '../cubits/profile-cubit/profile_cubit.dart';
import '../repository/profile_repository.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  ProfileScreen({Key? key}) : super(key: key);

  static Page page() => MaterialPage<void>(child: ProfileScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _firebaseFirestore
            .collection('users')
            .doc(context.read<AuthBloc>().state.targetID)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return BlocProvider(
              create: (context) => ProfileCubit(
                context.read<ProfileRepository>(),
                context.read<AuthRepository>(),
              )..setIntial(data),
              child: BlocListener<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state.status == ProfileStatus.error) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                  child: _ProfileView(data: data)),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final Map<String, dynamic> data;

  const _ProfileView({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: <Widget>[
                // const LabelText(label: 'duration'),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 15.0),
                //   child: TextFormField(
                //     initialValue: state.duration,
                //     keyboardType: TextInputType.number,
                //     decoration: const InputDecoration(
                //       contentPadding: EdgeInsets.only(left: 10),
                //       floatingLabelBehavior: FloatingLabelBehavior.always,
                //     ),
                //     onChanged: (duration) {
                //       context.read<ProfileCubit>().durationChanged(duration);
                //     },
                //   ),
                // ),
                const LabelText(label: 'Height (cm)'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    initialValue: state.height,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onChanged: (height) {
                      context.read<ProfileCubit>().heightChanged(height);
                    },
                  ),
                ),
                const LabelText(label: 'Weight (kg)'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    initialValue: state.weight,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onChanged: (weight) {
                      print(weight);
                      context.read<ProfileCubit>().weightChanged(weight);
                    },
                  ),
                ),
                const LabelText(label: 'Age'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    initialValue: state.age,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onChanged: (age) {
                      context.read<ProfileCubit>().ageChanged(age);
                    },
                  ),
                ),
                const LabelText(label: 'Duration of Illness'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    initialValue: state.duration,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    onChanged: (duration) {
                      context.read<ProfileCubit>().durationChanged(duration);
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.30,
                      left: MediaQuery.of(context).size.width * 0.30),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<ProfileCubit>().updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fixedSize: const Size(120, 40),
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class LabelText extends StatelessWidget {
  final String label;
  const LabelText({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master/cubits/chat-cubit/chat_cubit.dart';
import 'package:master/widgets/chat-widgets/view.dart';
import 'package:intl/intl.dart';

import '../../repository/auth_repository.dart';

class Message extends StatelessWidget {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        context.read<ChatCubit>().checkdocID();
        return StreamBuilder(
          stream: _firebaseFirestore
              .collection('users')
              .doc(context.read<AuthRepository>().currentUser.id)
              .collection('messages')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data.docs;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                        message: data[index]['message'],
                        date: DateFormat('dd/MM/yyyy, HH:mm')
                            .format(data[index]['date'].toDate()),
                        isMe: data[index]['userID'] ==
                            context.read<AuthRepository>().currentUser.id,
                        username: data[index]['username']);
                  },
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}

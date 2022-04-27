import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:master/widgets/bottom_nav_bar.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  ChatScreen({Key? key}) : super(key: key);

  static Page page() => MaterialPage<void>(child: ChatScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: _firebaseFirestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('messages')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data.docs;
            return ListView.builder(
              reverse: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: const <Widget>[
                    Expanded(
                      child: Text('Not implemented yet'),
                    ),
                  ],
                );
              },
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

// MessageBubble(
//                       message: data[index]['message'],
//                       date: DateFormat('dd/MM/yyyy, HH:mm')
//                           .format(data[index]['date'].toDate()),
//                       isMe: data[index]['userID'] ==
//                           FirebaseAuth.instance.currentUser!.uid,
//                       id: data[index].id,
//                       username: data[index].username,
//                     ),
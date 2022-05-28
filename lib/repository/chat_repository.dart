import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firebaseFirestore;

  ChatRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getElderlyDetail({
    required String userid,
  }) async {
    return await _firebaseFirestore.collection('users').doc(userid).get();
  }

  Future<void> createNewMessage({
    required String username,
    required String message,
    required String id,
    required String docID,
  }) async {
    try {
      final current = DateTime.now();

      final response = await _firebaseFirestore
          .collection('users')
          .doc(docID)
          .collection('messages')
          .orderBy("date", descending: true)
          .limit(1)
          .get();

      String newId = response.docs.isEmpty
          ? '0'
          : (int.parse(response.docs[0].id) + 1).toString();

      _firebaseFirestore
          .collection('users')
          .doc(docID)
          .collection('messages')
          .doc(newId)
          .set({
        'message': message,
        'date': DateTime.now(),
        'userID': id,
        'username': username,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

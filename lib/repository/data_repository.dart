import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepository {
  final FirebaseFirestore _firebaseFirestore;

  DataRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> createNewUser({
    required String id,
    required String username,
  }) async {
    await _firebaseFirestore.collection('users').doc(id).set({
      'username': username,
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class LinkCodeRepository {
  final FirebaseFirestore _firebaseFirestore;

  LinkCodeRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> updateLinkCode({
    required String id,
    required String code,
  }) async {
    await _firebaseFirestore.collection('users').doc(id).set({
      "link_code": code,
    }, SetOptions(merge: true));
  }
}

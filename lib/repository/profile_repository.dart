import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRepository {
  final FirebaseFirestore _firebaseFirestore;

  ProfileRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> updateProfile({
    required String id,
    required String duration,
    required String height,
    required String weight,
    required String age,
  }) async {
    await _firebaseFirestore.collection('users').doc(id).set({
      'duration': duration,
      'height': height,
      'weight': weight,
      'age': age,
    }, SetOptions(merge: true));
  }
}

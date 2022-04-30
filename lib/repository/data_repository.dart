import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DataRepository {
  final FirebaseFirestore _firebaseFirestore;

  DataRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<void> createNewUser({
    required String id,
    required String username,
    required String userType,
  }) async {
    String token = '';
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value!;
    });

    if (userType == 'Elderly') {
      await _firebaseFirestore.collection('users').doc(id).set({
        'username': username,
        'registration_token': [token],
        'userType': userType,
        'linked_account': []
      });
    } else {
      await _firebaseFirestore.collection('users').doc(id).set({
        'username': username,
        'registration_token': [token],
        'userType': userType,
      });
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getElderlyDetail({
    required String userid,
  }) async {
    return await _firebaseFirestore.collection('users').doc(userid).get();
  }

  Future<void> removeRegistrationToken({required String userid}) async {
    var token;
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value!;
    });

    await FirebaseFirestore.instance.collection('users').doc(userid).update({
      'registration_token': FieldValue.arrayRemove([token]),
    });
  }

  Future<void> addRegistrationToken({required String userid}) async {
    var token;
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value!;
    });

    await FirebaseFirestore.instance.collection('users').doc(userid).update({
      'registration_token': FieldValue.arrayUnion([token]),
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getHeartRate({
    required String userid,
    required String date,
  }) {
    return _firebaseFirestore
        .collection('users')
        .doc(userid)
        .collection('healthData')
        .doc(date)
        .snapshots();
  }

  Future<void> storeFitbitCredentials({
    required String id,
    required Map<String, dynamic> fitbitCredentials,
  }) async {
    await _firebaseFirestore.collection('users').doc(id).set({
      "access_token": fitbitCredentials['access_token'],
      "expires_in": DateTime.now().millisecondsSinceEpoch +
          fitbitCredentials['expires_in'] * 1000 -
          50000,
      "refresh_token": fitbitCredentials['refresh_token'],
      "user_id": fitbitCredentials['user_id'],
    });
  }

  Future<void> updateFitbitAccessToken({
    required String id,
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    await _firebaseFirestore.collection('users').doc(id).update({
      "access_token": accessToken,
      "refresh_token": refreshToken,
      "expires_in":
          DateTime.now().millisecondsSinceEpoch + expiresIn * 1000 - 50000,
    });
  }

  Future<void> createNewHeartRateRecord({
    required String id,
    required List data,
    required String date,
  }) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection('users')
          .doc(id)
          .collection('healthData')
          .doc(date)
          .get();

      if (!snapshot.exists) {
        await _firebaseFirestore
            .collection('users')
            .doc(id)
            .collection('healthData')
            .doc(date)
            .set({
          "heart_rate": FieldValue.arrayUnion([
            {data[0]: data[1]}
          ]),
        });
      } else {
        print(111111);
        await _firebaseFirestore
            .collection('users')
            .doc(id)
            .collection('healthData')
            .doc(date)
            .update({
          "heart_rate": FieldValue.arrayUnion([
            {data[0]: data[1]}
          ]),
        });
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String id,
    required String username,
    required String height,
    required String weight,
    required String age,
  }) async {
    await _firebaseFirestore.collection('users').doc(id).set({
      'username': username,
      'height': height,
      'weight': weight,
      'age': age,
    }, SetOptions(merge: true));
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

  Future<String> linkElderly({
    required String code,
    required String userId,
  }) async {
    try {
      final response = await _firebaseFirestore
          .collection('users')
          .where('link_code', isEqualTo: code)
          .get();

      print('data is ' + response.docs.isEmpty.toString());
      if (response.docs.isEmpty) {
        throw 'Link Code Is Invalid';
      }

      print(response.docs[0].id);

      await _firebaseFirestore
          .collection('users')
          .doc(response.docs[0].id)
          .update({
        'linked_account': FieldValue.arrayUnion([userId]),
      });

      await _firebaseFirestore
          .collection('users')
          .doc(userId)
          .set({'elderly': response.docs[0].id}, SetOptions(merge: true));

      return '';
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

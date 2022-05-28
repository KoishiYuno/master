import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:master/model/user.dart';

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  var currentUser = User.empty;
  var targetId = '';

  // Get current user, return empty user if not login
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      currentUser = user;

      return user;
    });
  }

  // Sign up method
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Email is not valid or badly formatted.');
      } else if (e.code == 'operation-not-allowed') {
        throw Exception('Operation is not allowed, please contact support');
      } else {
        throw Exception(e.code.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Log in method using email and password
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw Exception('Email is not valid or badly formatted.');
      } else if (e.code == 'user-disabled') {
        throw Exception('This user has been disabled. Please contact support.');
      } else if (e.code == 'user-not-found') {
        throw Exception('Email is not found, please create an account.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password, please try again.');
      } else {
        throw Exception(e.code.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addRegistrationToken({required String userid}) async {
    // ignore: prefer_typing_uninitialized_variables
    var token;
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value!;
    });

    await _firebaseFirestore.collection('users').doc(userid).update({
      'registration_token': FieldValue.arrayUnion([token]),
    });
  }

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
}

// Add get method for User object in FirebaseAuth package
extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, userName: displayName);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bcsp7b/services/authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  @override
  Future<String> currentUserUid() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.uid ?? '';
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signInWithEmailAndPassword({String? email, String? password}) async {
    try {
      final UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      final User? user = authResult.user;
      return user?.uid ?? '';
    } catch (e) {
      print('Sign in error: $e');
      return 'Error signing in: $e';
    }
  }

  @override
  Future<String> createUserWithEmailAndPassword({String? email, String? password}) async {
    try {
      final UserCredential authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      final User? user = authResult.user;
      return user?.uid ?? '';
    } catch (e) {
      print('Create user error: $e');
      return 'Error creating user: $e';
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final User? user = _firebaseAuth.currentUser;
    await user?.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    final User? user = _firebaseAuth.currentUser;
    return user?.emailVerified ?? false;
  }
}

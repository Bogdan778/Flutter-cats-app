import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  StreamSubscription<User?> get currentUser =>
      _auth.authStateChanges().listen((User? user) => user);

  Future<UserCredential> signInWithCredentials(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  Future<void> logout() => _auth.signOut();
}

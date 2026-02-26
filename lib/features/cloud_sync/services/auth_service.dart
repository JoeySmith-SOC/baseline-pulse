import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this._auth);

  final FirebaseAuth? _auth;

  bool get available => _auth != null;

  User? get user => _auth?.currentUser;

  Future<void> ensureAnonymousSignIn() async {
    if (_auth == null) {
      return;
    }
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }
}

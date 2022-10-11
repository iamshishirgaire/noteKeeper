import 'package:firebase_auth/firebase_auth.dart';

class LoginRepo {
  FirebaseAuth firebase = FirebaseAuth.instance;

  Future<LoginResult> login(String userEmail, String userPassword) async {
    try {
      var auth = await firebase.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
      return LoginResult(auth.user, "Login Success");
    } on FirebaseAuthException catch (e) {
      return LoginResult(null, e.message.toString());
    }
  }

  Future<bool> logout() async {
    try {
      await firebase.signOut();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}

class LoginResult {
  final User? user;
  final String message;
  LoginResult(this.user, this.message);
}

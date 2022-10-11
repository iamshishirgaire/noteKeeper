import 'package:firebase_auth/firebase_auth.dart';

class RegisterRepo {
  FirebaseAuth firebase = FirebaseAuth.instance;

  Future<RegisterLogin> register(
      String userEmail, String userPassword, String name) async {
    try {
      var auth = await firebase.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      firebase.currentUser?.updateDisplayName(name);
      return RegisterLogin(auth.user, "Registration Success");
    } on FirebaseAuthException catch (e) {
      return RegisterLogin(null, e.message.toString());
    }
  }
}

class RegisterLogin {
  final User? user;
  final String message;
  RegisterLogin(this.user, this.message);
}

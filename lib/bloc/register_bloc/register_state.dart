import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterState {}

class LoadingState extends RegisterState {}

class RegisterSucessState extends RegisterState {
  final User user;
  RegisterSucessState(this.user);
}

class RegisterFailureState extends RegisterState {
  String message;
  RegisterFailureState(this.message);
}

class RegisterInitialState extends RegisterState {}

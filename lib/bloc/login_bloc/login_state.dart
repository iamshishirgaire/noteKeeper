import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState {}

class LoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final User user;
  LoginSuccessState(this.user);
}

class LoginFailureState extends LoginState {
  String message;
  LoginFailureState(this.message);
}

class LogoutSuccessState extends LoginState {}

class LogoutFailureState extends LoginState {}

class LoginInitialState extends LoginState {}

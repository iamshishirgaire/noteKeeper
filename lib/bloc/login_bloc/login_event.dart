abstract class LoginEvent {}

class LoginButtonTappedEvent extends LoginEvent {
  final String email;
  final String password;
  LoginButtonTappedEvent(this.email, this.password);
}

class LogOutButtonTappedEvent extends LoginEvent {}

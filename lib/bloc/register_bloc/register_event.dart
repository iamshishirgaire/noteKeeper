abstract class RegisterEvent {}

class RegisterButtonTappedEvent extends RegisterEvent {
  final String email;
  final String password;
  final String name;
  RegisterButtonTappedEvent(this.email, this.password, this.name);
}

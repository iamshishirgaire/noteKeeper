import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginui/bloc/login_bloc/login_event.dart';
import 'package:loginui/bloc/login_bloc/login_state.dart';
import 'package:loginui/repository/login_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginButtonTappedEvent>((event, emit) async {
      emit(LoadingState());
      var result = await LoginRepo().login(event.email, event.password);
      if (result.user == null) {
        emit(LoginFailureState(result.message));
      } else {
        emit(LoginSuccessState(result.user!));
      }
    });
    on<LogOutButtonTappedEvent>((event, emit) async {
      emit(LoadingState());
      var result = await LoginRepo().logout();
      if (result == true) {
        emit(LogoutSuccessState());
      } else {
        (emit(LogoutFailureState()));
      }
    });
  }
}

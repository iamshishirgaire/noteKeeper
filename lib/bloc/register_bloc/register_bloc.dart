import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginui/bloc/register_bloc/register_event.dart';
import 'package:loginui/bloc/register_bloc/register_state.dart';
import 'package:loginui/repository/register_repo.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitialState()) {
    on<RegisterButtonTappedEvent>((event, emit) async {
      emit(LoadingState());
      var result = await RegisterRepo()
          .register(event.email, event.password, event.name);

      if (result.user == null) {
        emit(RegisterFailureState(result.message));
      } else {
        emit(RegisterSucessState(result.user!));
      }
    });
  }
}

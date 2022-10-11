import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginui/bloc/theme_bloc/theme_event.dart';
import 'package:loginui/bloc/theme_bloc/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(ThemeState initialState) : super(initialState) {
    on<ThemeModeToggleEvent>((event, emit) async {
      if (state is LightThemeState) {
        emit(DarkThemeState());
        final sp = await SharedPreferences.getInstance();
        sp.setBool("isDark", true);
      } else {
        emit(LightThemeState());
        final sp = await SharedPreferences.getInstance();
        sp.setBool("isDark", false);
      }
    });
  }
}

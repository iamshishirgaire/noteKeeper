import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginui/screens/note_screen.dart';
import 'package:loginui/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/theme_bloc/theme_bloc.dart';
import 'bloc/theme_bloc/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var sp = await SharedPreferences.getInstance();
  var isDark = sp.getBool("isDark") ?? false;

  await Firebase.initializeApp();
  runApp(MyApp(
    isDark: isDark,
  ));
}

class MyApp extends StatefulWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(
        widget.isDark == true ? DarkThemeState() : LightThemeState(),
      ),
      child: BlocConsumer<ThemeBloc, ThemeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  brightness: state is DarkThemeState
                      ? Brightness.dark
                      : Brightness.light,
                  useMaterial3: true,
                ),
                home: FirebaseAuth.instance.currentUser == null
                    ? const OnBoardingPage()
                    : const NoteListView(),
              );
            },
          );
        },
      ),
    );
  }
}

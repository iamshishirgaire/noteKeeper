import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loginui/screens/note_screen.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Login ",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("To Continue",
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 0, bottom: 20),
                    child: SvgPicture.asset(
                      "assets/login.svg",
                      height: 250,
                      width: 250,
                    )),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color.fromARGB(236, 24, 68, 8),
                    ),
                    suffixIcon: Icon(
                      Icons.clear,
                      color: Color.fromARGB(236, 24, 68, 8),
                    ),
                    hintText: "Input your Email",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.key,
                      color: Color.fromARGB(236, 24, 68, 8),
                    ),
                    suffixIcon: Icon(
                      Icons.remove_red_eye,
                      color: Color.fromARGB(236, 24, 68, 8),
                    ),
                    hintText: "Input your Password",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                      onPressed: () async {
                        try {
                          final auth = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                          if (auth.user != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NoteListView(),
                                ),
                                (e) => false);
                          }
                        } on FirebaseAuthException {
                          debugPrint("Cannot Login");
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

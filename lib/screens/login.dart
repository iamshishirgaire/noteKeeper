import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loginui/screens/note_screen.dart';
import 'package:loginui/screens/registeration.dart';
import 'package:lottie/lottie.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  bool canbeSeen = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
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
                  TextFormField(
                    validator: (email) {
                      if (email != null && email.isNotEmpty) {
                        return null;
                      } else {
                        return "Invalid Email";
                      }
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color.fromARGB(236, 24, 68, 8),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _emailController.clear();
                        },
                        icon: const Icon(Icons.clear),
                        color: const Color.fromARGB(236, 24, 68, 8),
                      ),
                      hintText: "Input your Email",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length >= 6) {
                        return null;
                      } else {
                        return "Password Length must be greater than 5 ";
                      }
                    },
                    obscureText: canbeSeen ? false : true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.key,
                        color: Color.fromARGB(236, 24, 68, 8),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            canbeSeen = !canbeSeen;
                          });
                        },
                        icon: Icon(
                          canbeSeen ? Icons.visibility : Icons.visibility_off,
                          color: const Color.fromARGB(236, 24, 68, 8),
                        ),
                      ),
                      hintText: "Input your Password",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2)),
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
                          if (_formKey.currentState!.validate()) {
                            try {
                              showDialog(
                                  barrierColor: Colors.white,
                                  context: context,
                                  builder: (_) => Lottie.asset(
                                        "assets/animation.json",
                                      ));
                              final auth = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                              await Future.delayed(const Duration(seconds: 5));
                              Navigator.pop(context);
                              if (auth.user != null) {
                                // ignore: use_build_context_synchronously
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const NoteListView(),
                                    ),
                                    (e) => false);
                              }
                            } on FirebaseAuthException catch (e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Container(
                                child: Text("${e.message}"),
                              )));
                            }
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have a account ?",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      TextButton(
                        onPressed: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterPage()));
                        }),
                        child: const Text(
                          "SignUp",
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

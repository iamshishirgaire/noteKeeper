import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loginui/screens/note_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign in",
                  style: TextStyle(fontSize: 30),
                ),
                const Text(
                  "To Continue",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: SvgPicture.asset(
                    "assets/signin.svg",
                    height: 150,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return "Name must not be empty";
                    }
                  },
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: "Input your Name",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return "Email must not be empty";
                    }
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Input your email",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return "Password must not be empty";
                    }
                  },
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: "Input your Password",
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                            final auth = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            FirebaseAuth.instance.currentUser!
                                .updateDisplayName(_nameController.text);

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Registration Success"),
                                backgroundColor: Colors.greenAccent,
                              ),
                            );
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => const NoteListView()),
                                ((route) => false));
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Container(
                              child: Text("${e.message}"),
                            )));
                          }
                        }
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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

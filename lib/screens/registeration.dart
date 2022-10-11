import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loginui/bloc/register_bloc/register_event.dart';
import 'package:loginui/screens/note_screen.dart';

import '../bloc/register_bloc/register_bloc.dart';
import '../bloc/register_bloc/register_state.dart';

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
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSucessState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Registered Successfully as ${state.user.email}")));
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const NoteListView()),
                (route) => false);
          } else if (state is RegisterFailureState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else {}
        },
        builder: (context, state) {
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
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2)),
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
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2)),
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
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            return MaterialButton(
                              color: const Color.fromARGB(255, 108, 99, 255),
                              disabledColor: Colors.grey,
                              onPressed: state is! LoadingState
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        BlocProvider.of<RegisterBloc>(context)
                                            .add(RegisterButtonTappedEvent(
                                                _emailController.text,
                                                _passwordController.text,
                                                _nameController.text));
                                      }
                                    }
                                  : null,
                              child: Text(
                                state is LoadingState
                                    ? "Registering........."
                                    : "Register",
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

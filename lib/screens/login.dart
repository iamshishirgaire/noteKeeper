import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
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
                const TextField(
                  decoration: InputDecoration(
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
                const TextField(
                  decoration: InputDecoration(
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
                      onPressed: () {},
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

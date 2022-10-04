import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.deepOrange,
                    width: 5,
                  )),
              child: CircleAvatar(
                child: Image.network(
                    "https://filmfare.wwmindia.com/content/2019/aug/hrithikroshanweb1565958352.jpg"),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Shishir Gaire",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "shishirgaire35@gmail.com",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 50,
          ),
          MaterialButton(
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 0,
            height: 45,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginUi()),
                  ((route) => false));
            },
            child: const Text("Log Out"),
          )
        ],
      ),
    );
  }
}
//
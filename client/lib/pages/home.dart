import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kairuchi'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 243, 182, 132),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              if (await GoogleSignIn().isSignedIn()) {
                await GoogleSignIn().signOut();
              }
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Text("Home Screen"),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:businessclient/pages/auth.dart';
import 'package:businessclient/widgets/profileCard.dart';

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
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          ProfileCard(),
          ElevatedButton(
            child: Text("Logout"),
            onPressed: () async {
              if (await GoogleSignIn().isSignedIn()) {
                await GoogleSignIn().signOut();
              }
              FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Auth()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

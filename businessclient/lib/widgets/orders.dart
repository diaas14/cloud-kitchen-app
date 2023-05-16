import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:businessclient/pages/auth.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
    );
  }
}

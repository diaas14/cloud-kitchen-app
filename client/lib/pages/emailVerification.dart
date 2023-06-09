import 'dart:async';

import 'package:client/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified) {
    _auth.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    
    super.dispose();
  }

  checkEmailVerified() async {
    await _auth.currentUser?.reload();

    setState(() {
      isEmailVerified = _auth.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email Successfully Verified!")));

      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified? Home() : SafeArea(
        child: Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1, -1),
            end: Alignment(1, 1),
            colors: <Color>[
              Theme.of(context).backgroundColor,
              Color.fromARGB(190, 255, 255, 255)
            ],
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/idli_illustration.png',
                width: MediaQuery.of(context).size.width / (1.3),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Check your inbox.\nWe have sent you an email at ${_auth.currentUser?.email}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Center(
                      child: Text(
                        'Verifying email...',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text('Resend'),
                      onPressed: () {
                        try {
                          FirebaseAuth.instance.currentUser
                              ?.sendEmailVerification();
                        } catch (e) {
                          debugPrint('$e');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    ));
}

import 'package:flutter/material.dart';
import 'package:client/widgets/signUp.dart';
import 'package:client/widgets/signIn.dart';
import 'package:client/widgets/googleAuthButton.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool signUp = true;

  void _toggleView() {
    setState(() => signUp = !signUp);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/idli_illustration.png',
                  width: width / (1.3),
                ),
              ),
              signUp
                  ? SignIn(toggleView: _toggleView)
                  : SignUp(toggleView: _toggleView),
              GoogleAuthButton(),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

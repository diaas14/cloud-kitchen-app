import 'package:flutter/material.dart';
import 'package:client/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  const SignUp({super.key, required this.toggleView});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool _obsureText = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final result = await registerWithEmailPassword(email, password);
      // if (result == 'success' && mounted) {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (_) => Home()),
      //   );
      // }
      Fluttertoast.showToast(
        msg: result,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: ((value) {
                final emailRegExp =
                    RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                if (!emailRegExp.hasMatch(value!)) {
                  return 'Enter valid Email';
                }
                return null;
              }),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter your Email',
              ),
              controller: _emailController,
            ),
            TextFormField(
              validator: ((value) {
                final passwordRegExp = RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}$');
                if (!passwordRegExp.hasMatch(value!)) {
                  return 'Enter valid Password';
                }
                return null;
              }),
              obscureText: _obsureText,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter your Password',
                suffixIcon: IconButton(
                  icon: Icon(
                      (_obsureText) ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obsureText = !_obsureText;
                    });
                  },
                ),
              ),
              controller: _passwordController,
            ),
            ElevatedButton(
              onPressed: () {
                _signUp(context);
              },
              child: Text('Sign Up'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: Text(
                    'Sign In',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

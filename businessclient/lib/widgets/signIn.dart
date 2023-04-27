import 'package:flutter/material.dart';
import 'package:businessclient/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool _obsureText = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final result = await signInWithEmailPassword(email, password);
      Fluttertoast.showToast(
        msg: result,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'We meet again!',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'We have missed working with you',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0x7fffffff),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    validator: ((value) {
                      final emailRegExp =
                          RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                      if (!emailRegExp.hasMatch(value!)) {
                        return 'Enter valid Email';
                      }
                      return null;
                    }),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Email*',
                      hintText: 'Enter your Email',
                    ),
                    controller: _emailController,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0x7fffffff),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
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
                      border: InputBorder.none,
                      labelText: 'Password*',
                      hintText: 'Enter your Password',
                      suffixIcon: IconButton(
                        icon: Icon((_obsureText)
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obsureText = !_obsureText;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController,
                  ),
                ),
                SizedBox(
                  width: width / 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _signIn(context);
                    },
                    child: Text('Sign In'),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

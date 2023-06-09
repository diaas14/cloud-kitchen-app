import 'package:flutter/material.dart';
import 'package:businessclient/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:businessclient/pages/foodServiceDetails.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  const SignUp({super.key, required this.toggleView});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool _obsureText = true;
  bool _obsureConfirmText = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  void _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();
      final result = await registerWithEmailPassword(
        name,
        email,
        password,
      );
      Fluttertoast.showToast(
        msg: result,
      );
      if (result == 'success' && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FoodServiceDetails()),
        );
      }
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
              "Set everything up",
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
              "We cannot wait to start working with you!",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    cursorColor: Color.fromARGB(255, 21, 120, 131),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Name*',
                      hintText: 'Enter your Name',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 21, 120, 131),
                      ),
                    ),
                    controller: _nameController,
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
                      final emailRegExp =
                          RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                      if (!emailRegExp.hasMatch(value!)) {
                        return 'Enter valid Email';
                      }
                      return null;
                    }),
                    cursorColor: Color.fromARGB(255, 21, 120, 131),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Email*',
                      hintText: 'Enter your Email',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 21, 120, 131),
                      ),
                    ),
                    controller: _emailController,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: const [
                        WidgetSpan(
                          child: Icon(
                            Icons.info,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text:
                              " Use a professional email for branding purposes to create a sense of credibility and professionalism",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
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
                    cursorColor: Color.fromARGB(255, 21, 120, 131),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Password*',
                      hintText: 'Enter your Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          (_obsureText)
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color.fromARGB(255, 21, 120, 131),
                        ),
                        onPressed: () {
                          setState(() {
                            _obsureText = !_obsureText;
                          });
                        },
                      ),
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 21, 120, 131),
                      ),
                    ),
                    controller: _passwordController,
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
                      if (value.trim() != _passwordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    }),
                    obscureText: _obsureConfirmText,
                    cursorColor: Color.fromARGB(255, 21, 120, 131),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Confirm Password*',
                      hintText: 'Enter your Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          (_obsureConfirmText)
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color.fromARGB(255, 21, 120, 131),
                        ),
                        onPressed: () {
                          setState(() {
                            _obsureConfirmText = !_obsureConfirmText;
                          });
                        },
                      ),
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 21, 120, 131),
                      ),
                    ),
                    controller: _confirmPasswordController,
                  ),
                ),
                SizedBox(
                  width: width / 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _signUp(context);
                    },
                    child: Text('Sign Up'),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Have an account already? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Text(
                        'Sign In',
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

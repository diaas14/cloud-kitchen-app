import 'package:flutter/material.dart';
import 'package:client/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GoogleAuthButton extends StatefulWidget {
  const GoogleAuthButton({super.key});

  @override
  State<GoogleAuthButton> createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends State<GoogleAuthButton> {
  void signInWithGoogleHandler() async {
    final result = await signInWithGoogle();
    Fluttertoast.showToast(
      msg: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    return SizedBox(
      width: width / 2,
      child: TextButton(
        onPressed: signInWithGoogleHandler,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icons/google_icon.png',
              height: 24,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

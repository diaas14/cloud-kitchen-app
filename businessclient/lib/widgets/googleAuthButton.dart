import 'package:flutter/material.dart';
import 'package:businessclient/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:businessclient/pages/foodServiceDetails.dart';
import 'package:businessclient/pages/home.dart';
import 'package:businessclient/pages/auth.dart';

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
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        if (result == 'registration complete') {
          return FoodServiceDetails();
        } else if (result == 'login success') {
          return Home();
        } else {
          return Auth();
        }
      }));
    }
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

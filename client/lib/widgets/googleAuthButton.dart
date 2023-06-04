import 'package:client/models/user.dart';
import 'package:flutter/material.dart';
import 'package:client/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class GoogleAuthButton extends StatefulWidget {
  const GoogleAuthButton({super.key});

  @override
  State<GoogleAuthButton> createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends State<GoogleAuthButton> {
  void signInWithGoogleHandler(UserProvider userProvider) async {
    final result = await signInWithGoogle(userProvider);
    Fluttertoast.showToast(
      msg: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return SizedBox(
      width: width / 2,
      child: TextButton(
        onPressed: () {
          signInWithGoogleHandler(userProvider);
        },
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

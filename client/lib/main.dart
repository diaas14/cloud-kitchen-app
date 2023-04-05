import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/auth.dart';
import 'package:client/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:client/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client/themes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      initialRoute: '/home',
      theme: themeData,
      routes: {
        '/home': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data == null) {
                    return Auth();
                  } else {
                    return Home();
                  }
                }
                return CircularProgressIndicator();
              }),
            ),
      },
    ),
  );
}

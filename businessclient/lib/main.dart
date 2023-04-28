import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:businessclient/themes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:businessclient/pages/auth.dart';
import 'package:businessclient/firebase_options.dart';
import 'package:businessclient/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load();
  } catch (e) {
    print('Error loading .env file: $e');
  }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(
    MaterialApp(
      initialRoute: '/',
      theme: themeData,
      home: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final User? user = snapshot.data;
            return user == null ? Auth() : Home();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    ),
  );
}

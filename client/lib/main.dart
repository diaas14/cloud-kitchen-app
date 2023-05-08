import 'package:client/firebase_options.dart';
import 'package:client/pages/auth.dart';
import 'package:client/pages/home.dart';
import 'package:client/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
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
      initialRoute: '/home',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => Material(
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: ((context, snapshot) {
                  if (snapshot.hasError) {
                    showDialog(
                      context: context, // Replace with your context
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text(snapshot.error.toString()),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                    return CircularProgressIndicator();
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
            ),
      },
    ),
  );
}

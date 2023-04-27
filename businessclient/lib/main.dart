import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:businessclient/themes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:businessclient/pages/auth.dart';
import 'package:businessclient/firebase_options.dart';
import 'package:businessclient/pages/foodServiceDetails.dart';

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
      theme: themeData,
      home: Auth(),
    ),
  );
}

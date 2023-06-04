import 'package:client/firebase_options.dart';
import 'package:client/pages/auth.dart';
import 'package:client/pages/home.dart';
import 'package:client/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:client/models/cartModel.dart';
import 'package:client/models/user.dart';

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

  final userProvider = UserProvider();
  await userProvider.loadUserData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartModel>(
          create: (context) => CartModel(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showDialog(
              context: context,
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
            if (snapshot.data != null) {
              return Home();
            } else {
              return Auth();
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

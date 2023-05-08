import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

Future<String> registerWithEmailPassword(
    String name, String email, String password) async {
  try {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    final token = await user?.getIdToken();
    final response = await http.post(
      Uri.parse('${apiUrl}api/profile/'),
      body: {
        'userId': user?.uid,
        'name': name,
        'email': user?.email,
        'projectId': Firebase.app().options.projectId,
      },
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return (response.statusCode == 201) ? 'success' : response.body;
  } on FirebaseAuthException catch (e) {
    return e.code;
  } catch (e) {
    return e.toString();
  }
}

Future<String> signInWithEmailPassword(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return 'success';
  } on FirebaseAuthException catch (e) {
    return e.code;
  } catch (e) {
    return e.toString();
  }
}

Future<String> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final user = userCredential.user;
    final token = await user?.getIdToken();

    if (userCredential.user != null &&
        userCredential.additionalUserInfo?.isNewUser == true) {
      final response = await http.post(
        Uri.parse('${apiUrl}api/profile/'),
        body: {
          'userId': user?.uid,
          'name': googleUser?.displayName,
          'email': user?.email,
          if (googleUser?.photoUrl != null) 'photoUrl': googleUser?.photoUrl,
          'projectId': Firebase.app().options.projectId,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 201) return response.body;
    }
    return 'success';
  } catch (e) {
    return e.toString();
  }
}

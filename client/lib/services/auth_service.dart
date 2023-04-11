import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];
final storage = FlutterSecureStorage();

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
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final token = await credential.user?.getIdToken();
    await storage.write(key: 'token', value: token);
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
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 201) return response.body;
    }
    await storage.write(key: 'token', value: token);
    return 'success';
  } catch (e) {
    return e.toString();
  }
}

Future<Map<String, dynamic>> fetchProfileData() async {
  if (_auth.currentUser != null) {
    final uid = _auth.currentUser?.uid;
    final res = await http.get(Uri.parse('${apiUrl}api/profile/${uid}'));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load profile data.');
    }
  }
  throw Exception('No user found.');
}

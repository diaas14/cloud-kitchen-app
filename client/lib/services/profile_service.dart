import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

Future<Map<String, dynamic>> fetchProfileData() async {
  if (_auth.currentUser != null) {
    final uid = _auth.currentUser?.uid;
    final res = await http.get(Uri.parse('${apiUrl}api/profile/$uid'));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load profile data.');
    }
  }
  throw Exception('No user found.');
}

Future<String> updateProfile(Map<String, dynamic> data) async {
  try {
    if (_auth.currentUser != null) {
      final uid = _auth.currentUser?.uid;
      final response = await http.post(
        Uri.parse('${apiUrl}api/profile/$uid'),
        body: data,
      );
      return (response.statusCode == 200) ? 'success' : response.body;
    } else {
      return ("User not found");
    }
  } catch (e) {
    return e.toString();
  }
}

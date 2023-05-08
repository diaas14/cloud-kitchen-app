import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

Future<String> saveServiceDetails(String serviceName, Position? pos) async {
  try {
    if (_auth.currentUser != null) {
      final uid = _auth.currentUser!.uid;
      final token = await _auth.currentUser!.getIdToken();
      var locationData =
          jsonEncode({'latitude': pos?.latitude, 'longitude': pos?.longitude});

      final response = await http.post(
        Uri.parse('${apiUrl}api/business-profile/$uid'),
        body: {
          'businessName': serviceName,
          'locationData': locationData,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return 'success';
      } else {
        return 'Failed to save service details: ${response.statusCode}';
      }
    } else {
      return 'No user found.';
    }
  } catch (e) {
    return e.toString();
  }
}

Future<Map<String, dynamic>> fetchServiceDetails() async {
  if (_auth.currentUser != null) {
    final uid = _auth.currentUser?.uid;
    final token = await _auth.currentUser?.getIdToken();
    final res = await http.get(
      Uri.parse('${apiUrl}api/business-profile/$uid'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load profile data.');
    }
  }
  throw Exception('No user found.');
}

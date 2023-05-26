import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

Future<List<Map<String, dynamic>>> fetchBusinessProfiles() async {
  final token = await _auth.currentUser?.getIdToken();
  final response = await http.get(
    Uri.parse('${apiUrl}api/business-profile/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final jsonProfiles = jsonDecode(response.body) as List<dynamic>;
    return jsonProfiles
        .map((profile) => Map<String, dynamic>.from(profile))
        .toList();
  } else {
    throw Exception('Failed to fetch profiles');
  }
}

Future<List<dynamic>> fetchMenu(String providerId) async {
  final token = await _auth.currentUser?.getIdToken();
  final response = await http.get(
    Uri.parse('${apiUrl}api/business-profile/menu/$providerId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    final menuList = jsonDecode(response.body)['menu'] as List<dynamic>;
    return menuList
        .map((menuItem) => Map<String, dynamic>.from(menuItem))
        .toList();
  } else {
    print(response.body);
    throw Exception('Failed to fetch profiles');
  }
}

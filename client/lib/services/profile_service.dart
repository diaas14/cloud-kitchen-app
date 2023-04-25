import 'dart:io';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

Future<Map<String, dynamic>> fetchProfileData() async {
  if (_auth.currentUser != null) {
    final uid = _auth.currentUser?.uid;
    final token = await _auth.currentUser?.getIdToken();
    final res = await http.get(
      Uri.parse('${apiUrl}api/profile/$uid'),
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

Future<String> updateProfile(
    Map<String, dynamic> data, XFile? imageFile) async {
  if (_auth.currentUser == null) return "Error: Current user is null";
  final uid = _auth.currentUser?.uid;
  final token = await _auth.currentUser?.getIdToken();
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(
      '${apiUrl}api/profile/$uid',
    ),
  );

  request.headers.addAll({
    'Authorization': 'Bearer $token',
  });

  data.forEach((key, value) {
    request.fields[key] = value.toString();
  });

  try {
    if (imageFile != null) {
      var imageStream = http.ByteStream(imageFile.openRead());
      var imageLength = await imageFile.length();
      var multipartFile = http.MultipartFile('image', imageStream, imageLength,
          filename: path.basename(imageFile.path));
      request.files.add(multipartFile);
    }
  } catch (e) {
    return e.toString();
  }
  var response = await request.send();

  if (response.statusCode == 200) {
    return 'Data and image uploaded successfully';
  } else {
    return 'Failed to upload data and image. Error: ${response.statusCode}';
  }
}

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

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

Future<String> updateBusinessData(
    Map<String, dynamic> data, XFile? imageFile) async {
  if (_auth.currentUser == null) return "Error: Current user is null";

  final uid = _auth.currentUser?.uid;
  final token = await _auth.currentUser?.getIdToken();

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(
      '${apiUrl}api/business-profile/$uid',
    ),
  );

  request.headers.addAll({
    'Authorization': 'Bearer $token',
  });

  data.forEach((key, value) {
    if (key == 'position') {
      request.fields['locationData'] = jsonEncode(
          {'latitude': data[key]?.latitude, 'longitude': data[key]?.longitude});
    } else if (key == 'place') {
      request.fields['address'] = jsonEncode({
        'street': data[key]?.street,
        'subLocality': data[key]?.subLocality,
        'locality': data[key]?.locality,
        'country': data[key]?.country
      });
    } else {
      request.fields[key] = value.toString();
    }
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

  print(request.fields);
  final response = await request.send();
  if (response.statusCode == 200) {
    return 'success';
  } else {
    return 'Failed to upload data and image. Error: ${response.statusCode}';
  }
}

Future<String> postImages(List<XFile> imageFiles) async {
  if (imageFiles.isEmpty) {
    return "Please select images to post.";
  }

  if (_auth.currentUser == null) {
    return "Error: Current user is null";
  }

  final uid = _auth.currentUser?.uid;
  final token = await _auth.currentUser?.getIdToken();

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(
      '${apiUrl}api/business-profile/images/$uid',
    ),
  );

  request.headers.addAll({
    'Authorization': 'Bearer $token',
  });

  try {
    for (var file in imageFiles) {
      var imageStream = http.ByteStream(file.openRead());
      var imageLength = await file.length();
      var multipartFile = http.MultipartFile(
        'images',
        imageStream,
        imageLength,
        filename: path.basename(file.path),
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      return "success";
    } else {
      print(response.toString());
      return "Error posting images: ${response.statusCode}";
    }
  } catch (e) {
    print(e);
    return "Error posting images: ${e.toString()}";
  }
}

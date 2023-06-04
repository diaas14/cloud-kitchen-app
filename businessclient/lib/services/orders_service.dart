import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

Future<List<Map<String, dynamic>>> fetchOrders() async {
  final userId = _auth.currentUser?.uid;
  final token = await _auth.currentUser?.getIdToken();
  final response = await http.get(
    Uri.parse('${apiUrl}api/orders/provider/${userId}'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final jsonOrders = jsonDecode(response.body) as List<dynamic>;
    return jsonOrders.map((order) => Map<String, dynamic>.from(order)).toList();
  } else {
    throw Exception('Failed to fetch orders');
  }
}

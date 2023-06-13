import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

Future<List<Map<String, dynamic>>> fetchPlacedOrders() async {
  final userId = _auth.currentUser?.uid;
  final token = await _auth.currentUser?.getIdToken();
  final response = await http.get(
    Uri.parse('${apiUrl}api/orders/provider/placed/${userId}'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final jsonOrders = jsonDecode(response.body) as List<dynamic>;
    return jsonOrders.map((order) => Map<String, dynamic>.from(order)).toList();
  } else {
    print("Failed to fetch Orders ${response.body}");
    throw Exception('Failed to fetch orders');
  }
}

Future<List<Map<String, dynamic>>> fetchPreparedOrders() async {
  final userId = _auth.currentUser?.uid;
  final token = await _auth.currentUser?.getIdToken();
  final response = await http.get(
    Uri.parse('${apiUrl}api/orders/provider/prepared/${userId}'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final jsonOrders = jsonDecode(response.body) as List<dynamic>;
    return jsonOrders.map((order) => Map<String, dynamic>.from(order)).toList();
  } else {
    print("Failed to fetch Orders ${response.body}");
    throw Exception('Failed to fetch orders');
  }
}

Future<List<Map<String, dynamic>>> fetchResolvedOrders() async {
  final userId = _auth.currentUser?.uid;
  final token = await _auth.currentUser?.getIdToken();
  final response = await http.get(
    Uri.parse('${apiUrl}api/orders/provider/resolved/${userId}'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    final jsonOrders = jsonDecode(response.body) as List<dynamic>;
    return jsonOrders.map((order) => Map<String, dynamic>.from(order)).toList();
  } else {
    print("Failed to fetch Orders ${response.body}");
    throw Exception('Failed to fetch orders');
  }
}

Future<void> changeOrderStatus(String orderStatus, String orderId) async {
  final token = await _auth.currentUser?.getIdToken();
  final response = await http.put(
    Uri.parse('${apiUrl}api/orders/status/${orderId}'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: {
      'status': orderStatus,
    },
  );

  if (response.statusCode == 200) {
    print('Order status changed successfully.');
  } else {
    print('Failed to change order status. Status code: ${response.body}');
  }
}

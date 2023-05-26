import 'dart:convert';

import 'package:client/models/cartModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

Future<String> placeOrder(Map<String, CartItem> cartItems) async {
  try {
    final uid = _auth.currentUser?.uid;
    final token = await _auth.currentUser?.getIdToken();
    final response = await http.post(
      Uri.parse('${apiUrl}api/orders/'),
      body: {
        'customerId': uid,
        'cartItems': jsonEncode(cartItems),
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

import 'dart:convert';

import 'package:client/models/cartModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String? apiUrl = dotenv.env['DEV_API_URL'];

Future<String> placeOrder(
    CartModel cartModel, Map<String, dynamic>? userData) async {
  try {
    final uid = _auth.currentUser?.uid;
    final token = await _auth.currentUser?.getIdToken();

    final cartItems = cartModel.items;
    final providerDetails = cartModel.providerDetails;
    final providerId = providerDetails["userId"];
    final providerDetailsModified = Map.from(providerDetails);
    providerDetailsModified.remove("userId");
    providerDetailsModified.remove("location");
    providerDetailsModified.remove("address");
    final price = cartModel.totalCartPrice;

    final requestBody = {
      'customerId': uid,
      'providerId': providerId,
      'providerDetails': jsonEncode(providerDetailsModified),
      'cartItems': jsonEncode(cartItems),
      'price': price.toString(),
    };

    if (userData != null) {
      requestBody['userData'] = jsonEncode(userData);
    }

    final response = await http.post(
      Uri.parse('${apiUrl}api/orders/'),
      body: requestBody,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return (response.statusCode == 201) ? 'success' : response.body;
  } on FirebaseAuthException catch (e) {
    return e.code;
  } catch (e) {
    print(e);
    return e.toString();
  }
}

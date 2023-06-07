import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  final Map<String, dynamic> order;
  const Order({super.key, required this.order});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Text("Your order will be displayed here."),
    );
  }
}

import 'package:businessclient/pages/placedOrders.dart';
import 'package:businessclient/pages/preparedOrders.dart';
import 'package:businessclient/pages/resolvedOrders.dart';
import 'package:businessclient/widgets/ordersList.dart';
import 'package:flutter/material.dart';
import 'package:businessclient/services/orders_service.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Placed Orders',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlacedOrders()),
            );
          },
        ),
        GestureDetector(
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Prepared Orders',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PreparedOrders()),
            );
          },
        ),
        GestureDetector(
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Resolved Orders',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResolvedOrders(),
              ),
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:businessclient/services/orders_service.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    _orders = await fetchOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        final customerData = order['customerData'] ?? {};
        final email = customerData['email'] ?? '';
        final name = customerData['name'] ?? '';
        final photoUrl = customerData['photoUrl'] ?? '';
        final customerId = customerData['customerId'] ?? '';
        final items = order['items'] ?? [];
        final orderId = order['orderId'] ?? '';
        final price = order['price'] ?? 0.0;
        final providerDetails = order['providerDetails'] ?? {};
        final businessName = providerDetails['businessName'] ?? '';
        final businessPicsUrls = providerDetails['businessPicsUrls'] ?? [];
        return GestureDetector(
          onTap: () {
            // Handle the tap on the list item
            // e.g., navigate to a details page
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: $orderId',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                    title: Text(name),
                    subtitle: Text(email),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Business Name: $businessName',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Price: $price',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Items:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final itemId = item['id'] ?? '';
                      final itemName = item['name'] ?? '';
                      final itemPrice = item['price'] ?? '';
                      final itemQuantity = item['units'] ?? '';

                      return ListTile(
                        title: Text(itemName),
                        subtitle:
                            Text('Price: $itemPrice, Quantity: $itemQuantity'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

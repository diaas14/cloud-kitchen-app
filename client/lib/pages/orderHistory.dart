import 'package:client/pages/order.dart';
import 'package:flutter/material.dart';
import 'package:client/services/order_service.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
        backgroundColor: Color.fromARGB(190, 61, 135, 118),
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          final orderDateTime = DateTime.fromMillisecondsSinceEpoch(
              order["timestamp"]["_seconds"] * 1000 +
                  order["timestamp"]["_nanoseconds"] ~/ 1000000);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Order(order: order)),
              );
            },
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'Order placed at $orderDateTime',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            // fontStyle: FontStyle.italic,
                          ),
                        )),
                    SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 230, 230, 230),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              order['providerDetails']['imageUrl'] != null
                                  ? NetworkImage(
                                      order['providerDetails']['imageUrl'])
                                  : AssetImage('assets/icons/kairuchi_icon.png')
                                      as ImageProvider<Object>,
                        ),
                        title: Text(
                          order['providerDetails']['businessName'],
                        ),
                        subtitle: Text(order['providerDetails']['email']),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Items',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order['items'].length,
                      itemBuilder: (context, index) {
                        final item = order['items'][index];

                        final itemName = item['name'] ?? '';
                        final itemPrice = item['price'] ?? '';
                        final itemQuantity = item['units'] ?? '';

                        return ListTile(
                          title: Text('$itemQuantity x $itemName'),
                          subtitle: Text('\u20B9$itemPrice'),
                        );
                      },
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '\u20B9${order['price']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

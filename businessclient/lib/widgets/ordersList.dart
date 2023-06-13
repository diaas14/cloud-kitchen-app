import 'package:businessclient/services/orders_service.dart';
import 'package:flutter/material.dart';

class OrdersList extends StatefulWidget {
  final String orderStatus;
  const OrdersList({super.key, required this.orderStatus});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    List<Map<String, dynamic>> orders;

    switch (widget.orderStatus) {
      case 'placed':
        orders = await fetchPlacedOrders();
        break;
      case 'prepared':
        orders = await fetchPreparedOrders();
        break;
      case 'resolved':
        orders = await fetchResolvedOrders();
        break;
      default:
        orders = [];
    }

    setState(() {
      _orders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        final orderDateTime = DateTime.fromMillisecondsSinceEpoch(
            order["timestamp"]["_seconds"] * 1000 +
                order["timestamp"]["_nanoseconds"] ~/ 1000000);
        return GestureDetector(
          onTap: () {},
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
                        backgroundImage: order['customerDetails']['photoUrl'] !=
                                null
                            ? NetworkImage(order['customerDetails']['photoUrl'])
                            : AssetImage('assets/icons/kairuchi_icon.png')
                                as ImageProvider<Object>,
                      ),
                      title: Text(
                        order['customerDetails']['name'],
                      ),
                      subtitle: Text(order['customerDetails']['email']),
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
                  Text(order["orderStatus"]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

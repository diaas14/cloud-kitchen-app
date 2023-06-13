import 'package:businessclient/services/orders_service.dart';
import 'package:flutter/material.dart';

class ResolvedOrders extends StatefulWidget {
  const ResolvedOrders({super.key});

  @override
  State<ResolvedOrders> createState() => _ResolvedOrdersState();
}

class _ResolvedOrdersState extends State<ResolvedOrders> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      _isLoading = true;
    });

    List<Map<String, dynamic>> orders;
    orders = await fetchResolvedOrders();

    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Resolved Orders"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(190, 61, 135, 118),
          elevation: 0,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _orders.isEmpty
                ? Center(
                    child: Text("No Resolved Orders"),
                  )
                : ListView.builder(
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
                                      backgroundImage: order['customerDetails']
                                                  ['photoUrl'] !=
                                              null
                                          ? NetworkImage(
                                              order['customerDetails']
                                                  ['photoUrl'])
                                          : AssetImage(
                                                  'assets/icons/kairuchi_icon.png')
                                              as ImageProvider<Object>,
                                    ),
                                    title: Text(
                                      order['customerDetails']['name'],
                                    ),
                                    subtitle:
                                        Text(order['customerDetails']['email']),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Order Status',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      order['orderStatus'].toUpperCase(),
                                      style: const TextStyle(
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
                  ));
  }
}

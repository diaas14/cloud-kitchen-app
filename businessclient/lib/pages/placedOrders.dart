import 'package:businessclient/services/orders_service.dart';
import 'package:flutter/material.dart';

class PlacedOrders extends StatefulWidget {
  const PlacedOrders({Key? key});

  @override
  State<PlacedOrders> createState() => _PlacedOrdersState();
}

class _PlacedOrdersState extends State<PlacedOrders> {
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
    orders = await fetchPlacedOrders();

    setState(() {
      _orders = orders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Placed Orders"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(190, 61, 135, 118),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Text("No Placed Orders"),
                )
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    final orderDateTime = DateTime.fromMillisecondsSinceEpoch(
                      order["timestamp"]["_seconds"] * 1000 +
                          order["timestamp"]["_nanoseconds"] ~/ 1000000,
                    );

                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        elevation: 3,
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 230, 230, 230),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: order['customerDetails']
                                                ['photoUrl'] !=
                                            null
                                        ? NetworkImage(
                                            order['customerDetails']
                                                ['photoUrl'],
                                          )
                                        : const AssetImage(
                                            'assets/icons/kairuchi_icon.png',
                                          ) as ImageProvider<Object>,
                                  ),
                                  title: Text(order['customerDetails']['name']),
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
                                physics: const NeverScrollableScrollPhysics(),
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
                                  const Text(
                                    'Total Price',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '\u20B9${order['price']}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await changeOrderStatus(
                                        'prepared', order["orderId"]);
                                    await fetchOrders();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  child: Text("Update to Prepared"),
                                ),
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

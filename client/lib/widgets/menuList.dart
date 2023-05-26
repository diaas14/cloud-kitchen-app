import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/models/cartModel.dart';

class MenuList extends StatefulWidget {
  final List<dynamic> items;
  final String providerId;

  const MenuList({Key? key, required this.items, required this.providerId})
      : super(key: key);

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  void _addItemToCart(String itemId, String itemName, double itemPrice,
      String? itemImgUrl, CartModel cart) {
    final item = CartItem(
      id: itemId,
      providerId: widget.providerId,
      name: itemName,
      price: itemPrice,
      imageUrl: itemImgUrl,
      units: 1,
    );
    try {
      cart.addItem(item);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    if (widget.items.isEmpty) {
      return Center(
        child: Text("Uh Oh, No Items Available"),
      );
    }
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final menuItem = widget.items[index];
        final itemId = menuItem['itemId'];
        final itemName = menuItem['itemName'] ?? '';
        final itemDescription = menuItem['itemDescription'] ?? '';
        final itemPrice = (menuItem['itemPrice'] ?? 0).toDouble();
        final itemQuantity = menuItem['itemQuantity'] ?? 0;
        final itemImgUrl = menuItem['itemImgUrl'];
        return Card(
          child: ListTile(
            title: Text(
              itemName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                fontSize: 22,
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        itemDescription,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          'Price \u20B9$itemPrice',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Quantity $itemQuantity',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_drop_up),
                            onPressed: cart.items[itemId] == null ||
                                    cart.items[itemId]!.getUnits() <
                                        itemQuantity
                                ? () {
                                    _addItemToCart(itemId, itemName, itemPrice,
                                        itemImgUrl, cart);
                                  }
                                : null,
                          ),
                          Text(
                            cart.items[itemId] == null
                                ? '0'
                                : cart.items[itemId]!.getUnits().toString(),
                          ),
                          IconButton(
                              icon: Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                cart.removeItemFromCart(itemId);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: itemImgUrl != null
                      ? Image.network(
                          itemImgUrl,
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/icons/kairuchi_icon.png',
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

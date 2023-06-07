import 'package:client/pages/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:client/models/cartModel.dart';

class MenuItemPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final Map<String, dynamic> providerProfile;
  const MenuItemPage(
      {super.key, required this.item, required this.providerProfile});

  @override
  State<MenuItemPage> createState() => _MenuItemPageState();
}

class _MenuItemPageState extends State<MenuItemPage> {
  void _addItemToCart(String itemId, String itemName, double itemPrice,
      String? itemImgUrl, CartModel cart) {
    final item = CartItem(
      id: itemId,
      name: itemName,
      price: itemPrice,
      imageUrl: itemImgUrl,
      units: 1,
    );
    try {
      cart.addItem(item, widget.providerProfile);
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final cart = Provider.of<CartModel>(context);
    final menuItem = widget.item;
    final itemId = menuItem['itemId'];
    final itemName = menuItem['itemName'] ?? '';
    final itemDescription = menuItem['itemDescription'] ?? '';
    final itemPrice = (menuItem['itemPrice'] ?? 0).toDouble();
    final itemQuantity = menuItem['itemQuantity'] ?? 0;
    final itemImgUrl = menuItem['itemImgUrl'];
    final itemTags = menuItem['itemTags'] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Item"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(190, 61, 135, 118),
        elevation: 0,
        actions: [
          Row(
            children: [
              Consumer<CartModel>(
                builder: (context, cartModel, _) {
                  int cartItemCount = cartModel.cartItemCount;
                  return Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Cart()),
                          );
                        },
                      ),
                      if (cartItemCount > 0)
                        Positioned(
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$cartItemCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: itemImgUrl != null
                  ? Image.network(
                      itemImgUrl,
                      width: width,
                      height: height / 3,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/icons/kairuchi_icon.png',
                      width: width,
                      height: height / 3,
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      itemDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    // ListView.builder(
                    //   physics: NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: itemTags.length,
                    //   itemBuilder: (context, index) {
                    //     final tag = itemTags[index];
                    //     return Container(
                    //       margin: EdgeInsets.all(4),
                    //       padding:
                    //           EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           width: 1.5,
                    //         ),
                    //       ),
                    //       child: Text(
                    //         tag,
                    //         style: TextStyle(),
                    //       ),
                    //     );
                    //   },
                    // ),
                    SizedBox(height: 8.0),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: itemTags.map<Widget>((tag) {
                        return Chip(
                          label: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          backgroundColor: Color.fromARGB(255, 234, 244, 241),
                          labelStyle: TextStyle(color: Colors.white),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '\u20B9$itemPrice',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(190, 61, 135, 118),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity Available',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          itemQuantity.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(190, 61, 135, 118),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Units',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 234, 244, 241),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_drop_up),
                                onPressed: itemQuantity > 0 &&
                                        (cart.items[itemId] == null ||
                                            cart.items[itemId]!.getUnits() <
                                                itemQuantity)
                                    ? () {
                                        _addItemToCart(itemId, itemName,
                                            itemPrice, itemImgUrl, cart);
                                      }
                                    : null,
                              ),
                              Text(
                                cart.items[itemId] == null
                                    ? '0'
                                    : cart.items[itemId]!.getUnits().toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(190, 61, 135, 118),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                onPressed: cart.items[itemId] != null
                                    ? () {
                                        cart.removeItemFromCart(itemId);
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Cart()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        icon: Icon(Icons.shopping_cart_outlined),
                        label: Text('View Cart'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:client/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:client/models/cartModel.dart';
import 'package:client/services/order_service.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Color.fromARGB(190, 61, 135, 118),
      ),
      body: Consumer<CartModel>(
        builder: (context, cartModel, _) {
          Map<String, CartItem> cartItems = cartModel.items;
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          if (cartItems.isEmpty) {
            return Center(
              child: Text('No items in the cart'),
            );
          }
          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      'Products Sold By ${cartModel.providerDetails["businessName"]}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      )),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    CartItem cartItem = cartItems.values.elementAt(index);
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cartItem.name} x ${cartItem.units}',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '\u20B9${cartItem.price}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
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
                      '\u20B9${cartModel.totalCartPrice}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                              190, 61, 135, 118), // Background color
                        ),
                        child: TextButton(
                          onPressed: () {
                            cartModel.clearCart();
                          },
                          child: Text(
                            "Clear Cart",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(
                              190, 61, 135, 118), // Background color
                        ),
                        child: TextButton(
                          onPressed: () async {
                            print(cartModel);
                            print(userProvider.userData);
                            String res = await placeOrder(
                                cartModel, userProvider.userData);
                            Fluttertoast.showToast(msg: res);
                            cartModel.clearCart();
                          },
                          child: Text(
                            "Place Order",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

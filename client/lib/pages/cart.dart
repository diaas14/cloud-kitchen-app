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
          return Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    CartItem cartItem = cartItems.values.elementAt(index);
                    return ListTile(
                      title: Text(cartItem.name),
                      subtitle: Text('Quantity: ${cartItem.units}'),
                    );
                  },
                ),
              ),
              Text('Price \u20B9${cartModel.totalCartPrice}'),
              TextButton(
                onPressed: () async {
                  print(cartModel);
                  print(userProvider.userData);
                  String res =
                      await placeOrder(cartModel, userProvider.userData);
                  Fluttertoast.showToast(msg: res);
                  cartModel.clearCart();
                },
                child: Text("Place Order"),
              ),
              TextButton(
                child: Text("Clear Cart"),
                onPressed: () {
                  cartModel.clearCart();
                },
              )
            ],
          );
        },
      ),
    );
  }
}

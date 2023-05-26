import 'package:client/models/cartModel.dart';
import 'package:client/pages/cart.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/profile.dart';
import 'package:client/widgets/menu.dart';
import 'package:client/widgets/menuList.dart';
import 'package:provider/provider.dart';

class FoodProvider extends StatefulWidget {
  final Map<String, dynamic> profile;
  const FoodProvider({super.key, required this.profile});

  @override
  State<FoodProvider> createState() => _FoodProviderState();
}

class _FoodProviderState extends State<FoodProvider> {
  @override
  Widget build(BuildContext context) {
    print("${widget.profile}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 36, 151, 164),
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
          ),
        ],
      ),
      body: Column(
        children: [
          Menu(profile: widget.profile),
          Expanded(
            child: MenuList(
              items: widget.profile["menu"] ?? [],
              providerId: widget.profile["userId"],
            ),
          ),
        ],
      ),
    );
  }
}
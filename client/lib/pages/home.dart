import 'package:client/models/cartModel.dart';
import 'package:client/widgets/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:client/pages/profile.dart';
import 'package:client/widgets/mapInterface.dart';
import 'package:client/widgets/foodProviders.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:client/pages/cart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedItem = 0;

  final _screens = <Widget>[
    const HomeScreen(),
    const MapInterface(),
    const FoodProviders(),
    const Profile()
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.location_pin,
    Icons.soup_kitchen_outlined,
    Icons.person_outline_sharp
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(190, 61, 135, 118),
        elevation: 0,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.logout),
                color: Colors.white,
                onPressed: () async {
                  if (await GoogleSignIn().isSignedIn()) {
                    await GoogleSignIn().signOut();
                  }
                  FirebaseAuth.instance.signOut();
                },
              ),
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
      body: Stack(
        children: [
          _screens.elementAt(_selectedItem),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 25, right: 25),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: Center(
                    child: ListView.builder(
                      itemCount: _icons.length,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedItem = i;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 250),
                            width: 35,
                            decoration: BoxDecoration(
                              border: i == _selectedItem
                                  ? Border(
                                      top: BorderSide(
                                      width: 3.0,
                                      color: Color.fromARGB(190, 61, 135, 118),
                                    ))
                                  : null,
                            ),
                            child: Icon(
                              _icons[i],
                              size: 32,
                              color: i == _selectedItem
                                  ? Color.fromARGB(190, 61, 135, 118)
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ),
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

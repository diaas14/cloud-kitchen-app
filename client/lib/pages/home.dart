import 'package:client/models/cartModel.dart';
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
    const MapInterface(),
    const FoodProviders(),
    const Profile()
  ];

  void _onItemTapped(int idx) {
    setState(
      () {
        _selectedItem = idx;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 36, 151, 164),
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
      body: _screens.elementAt(_selectedItem),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Food Providers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        unselectedItemColor: Color.fromARGB(255, 21, 120, 131),
        currentIndex: _selectedItem,
        selectedItemColor: Color.fromARGB(255, 21, 120, 131),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

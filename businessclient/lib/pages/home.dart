import 'package:businessclient/pages/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:businessclient/pages/profile.dart';
import 'package:businessclient/widgets/orders.dart';
import 'package:businessclient/widgets/manageMenu.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:businessclient/widgets/homeScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedItem = 0;

  final _screens = <Widget>[
    const HomeScreen(),
    const ManageMenu(),
    const Orders(),
    const Profile()
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.menu_book_outlined,
    Icons.shopping_bag_outlined,
    Icons.person_outline_sharp
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 36, 151, 164),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () async {
              if (await GoogleSignIn().isSignedIn()) {
                await GoogleSignIn().signOut();
              }
              FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Auth()),
                );
              }
            },
          ),
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
                              // gradient: i == _selectedItem
                              //     ? LinearGradient(
                              //         colors: [
                              //             Color(0xbf8fd1c2),
                              //             Color.fromARGB(255, 255, 255, 255)
                              //           ],
                              //         begin: Alignment.topCenter,
                              //         end: Alignment.bottomCenter)
                              //     : null,
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

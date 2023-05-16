import 'package:flutter/material.dart';
import 'package:businessclient/pages/profile.dart';
import 'package:businessclient/widgets/orders.dart';
import 'package:businessclient/widgets/manageMenu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedItem = 0;

  final _screens = <Widget>[
    const ManageMenu(),
    const Orders(),
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
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ],
      ),
      body: _screens.elementAt(_selectedItem),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Manage Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Orders",
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

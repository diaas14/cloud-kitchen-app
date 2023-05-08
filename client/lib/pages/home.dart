import 'package:flutter/material.dart';
import 'package:client/widgets/profile.dart';
import 'package:client/widgets/mapInterface.dart';
import 'package:client/widgets/foodProviders.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedItem = 0;

  final _screens = <Widget>[
    const MapInterface(),
    const Profile(),
    const FoodProviders()
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
      ),
      body: _screens.elementAt(_selectedItem),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Food Providers",
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

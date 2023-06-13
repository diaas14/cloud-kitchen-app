import 'package:businessclient/pages/editMenuItem.dart';
import 'package:businessclient/widgets/menuItemCard.dart';
import 'package:flutter/material.dart';
import 'package:businessclient/pages/addMenuItem.dart';
import 'package:businessclient/services/profile_service.dart';

class ManageMenu extends StatefulWidget {
  const ManageMenu({super.key});

  @override
  State<ManageMenu> createState() => _ManageMenuState();
}

class _ManageMenuState extends State<ManageMenu> {
  List<Map<String, dynamic>> _menu = [];

  Future<void> _getItems() async {
    final result = await fetchMenuItems();
    setState(() {
      _menu = result;
    });
  }

  @override
  void didPopNext() {
    _getItems(); // Call _getItems when returning to this page
  }

  @override
  void initState() {
    super.initState();
    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMenuItem()),
              ).then((value) {
                if (value == true) {
                  _getItems(); // Refresh menu items when returning from EditMenuItem
                }
              });
            },
            icon: Icon(Icons.add),
          ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _menu.length,
          itemBuilder: (context, index) {
            final menuItem = _menu[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditMenuItem(item: menuItem)),
                ).then((value) {
                  if (value == true) {
                    _getItems(); // Refresh menu items when returning from EditMenuItem
                  }
                });
              },
              child: MenuItemCard(
                item: menuItem,
              ),
            );
          },
        ),
      ],
    );
  }
}

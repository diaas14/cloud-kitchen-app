import 'package:flutter/material.dart';
import 'package:businessclient/widgets/menuList.dart';
import 'package:businessclient/pages/addMenuItem.dart';

class ManageMenu extends StatefulWidget {
  const ManageMenu({super.key});

  @override
  State<ManageMenu> createState() => _ManageMenuState();
}

class _ManageMenuState extends State<ManageMenu> {
  @override
  void initState() {
    super.initState();
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
              );
            },
            icon: Icon(Icons.add),
          ),
        ),
        Expanded(child: MenuList()),
      ],
    );
  }
}

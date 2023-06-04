import 'package:flutter/material.dart';
import 'package:businessclient/services/profile_service.dart';
import 'package:businessclient/pages/addMenuItem.dart';

class MenuList extends StatefulWidget {
  const MenuList({super.key});

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  List<Map<String, dynamic>> _items = [];

  Future<void> _getItems() async {
    final result = await fetchMenuItems();
    setState(() {
      _items = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Center(
        child: Text("Uh Oh, No Items Available"),
      );
    }
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final menuItem = _items[index];
        final itemName = menuItem['itemName'] ?? '';
        final itemDescription = menuItem['itemDescription'] ?? '';
        final itemPrice = menuItem['itemPrice'] ?? '';
        final itemQuantity = menuItem['itemQuantity'] ?? 0;
        final itemImgUrl = menuItem['itemImgUrl'];
        return Card(
          child: ListTile(
            title: Text(
              itemName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                fontSize: 22,
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      itemDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            16), // Adjust the border radius as needed
                        border: Border.all(
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4), // Adjust the padding as needed
                      child: Text(
                        'Price \u20B9$itemPrice',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Quantity $itemQuantity',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: itemImgUrl != null
                      ? Image.network(
                          itemImgUrl,
                          width: 80.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          width: 80.0,
                          height: 80.0,
                          'assets/icons/kairuchi_icon.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

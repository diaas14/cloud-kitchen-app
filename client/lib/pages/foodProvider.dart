import 'package:flutter/material.dart';
import 'package:client/pages/profile.dart';
import 'package:client/widgets/menu.dart';
import 'package:client/widgets/menuList.dart';

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
      body: Column(
        children: [
          Menu(profile: widget.profile),
          Expanded(
            child: MenuList(items: widget.profile["menu"] ?? []),
          ),
        ],
      ),
    );
  }
}

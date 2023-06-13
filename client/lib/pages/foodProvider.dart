import 'package:client/models/cartModel.dart';
import 'package:client/pages/cart.dart';
import 'package:client/widgets/foodProviderProfile.dart';
import 'package:client/widgets/imageGallery.dart';
import 'package:client/widgets/menuItemCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/services/business_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'menuItemPage.dart';

class FoodProvider extends StatefulWidget {
  final Map<String, dynamic> profile;
  const FoodProvider({super.key, required this.profile});

  @override
  State<FoodProvider> createState() => _FoodProviderState();
}

class _FoodProviderState extends State<FoodProvider> {
  List<Map<String, dynamic>> _menu = [];

  @override
  void initState() {
    super.initState();
    _fetchMenu();
  }

  Future<void> _fetchMenu() async {
    final result = await fetchMenu(widget.profile["userId"]);
    setState(() {
      _menu = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(190, 61, 135, 118),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FoodProviderProfile(profile: widget.profile),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 241, 230),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(vertical: 18.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Photos",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ImageGallery(
                        imageUrls:
                            widget.profile.containsKey("businessPicsUrls")
                                ? widget.profile["businessPicsUrls"]
                                : []),
                  ]),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text(
                        "Menu Items",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
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
                                builder: (context) => MenuItemPage(
                                  item: menuItem,
                                  providerProfile: widget.profile,
                                ),
                              ),
                            ).then((value) {
                              if (value == true) {
                                _fetchMenu();
                              }
                            });
                          },
                          child: MenuItemCard(
                            item: menuItem,
                          ),
                        );
                      },
                    ),
                  ]),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          size: 18,
                          color: Color.fromARGB(190, 61, 135, 118),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "About",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          child: widget.profile.containsKey("photoUrl")
                              ? ClipOval(
                                  child: Image.network(
                                    widget.profile["photoUrl"],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : IconTheme(
                                  data: IconThemeData(
                                    size: 24,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.profile['name'],
                                  style: TextStyle(fontSize: 24)),
                              SizedBox(height: 4),
                              GestureDetector(
                                onTap: () {
                                  final Uri _emailLaunchUri = Uri(
                                      scheme: 'mailto',
                                      path: widget.profile[
                                          'email'], // Replace with the actual email address
                                      queryParameters: {
                                        'subject': 'Hello'
                                      } // Optional subject parameter
                                      );

                                  launchUrl(_emailLaunchUri);
                                },
                                child: Text(widget.profile['email']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

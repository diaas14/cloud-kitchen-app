import 'package:client/pages/foodProvider.dart';
import 'package:flutter/material.dart';

class FoodProviderCard extends StatefulWidget {
  final Map<String, dynamic> profile;
  const FoodProviderCard({super.key, required this.profile});

  @override
  State<FoodProviderCard> createState() => _FoodProviderCardState();
}

class _FoodProviderCardState extends State<FoodProviderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodProvider(profile: widget.profile),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.profile.containsKey('businessName'))
                      Text(
                        widget.profile['businessName'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 8.0),
                    if (widget.profile.containsKey('location'))
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 6.0),
                            child: Icon(Icons.location_pin,
                                size: 18,
                                color: Color.fromARGB(190, 61, 135, 118)),
                          ),
                          Text(
                            '${widget.profile['address']['street']}, ${widget.profile['address']['subLocality']}, ${widget.profile['address']['locality']}, ${widget.profile['address']['country']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: widget.profile['imageUrl'] != null
                    ? Image.network(
                        widget.profile['imageUrl'],
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/icons/kairuchi_icon.png',
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      ),
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(6.0),
              //       child: CircleAvatar(
              //         radius: 22,
              //         child: widget.profile.containsKey("photoUrl")
              //             ? ClipOval(
              //                 child: Image.network(
              //                   widget.profile["photoUrl"],
              //                   fit: BoxFit.cover,
              //                 ),
              //               )
              //             : IconTheme(
              //                 data: IconThemeData(
              //                   size: 20,
              //                 ),
              //                 child: Icon(
              //                   Icons.person,
              //                 ),
              //               ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(6.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           RichText(
              //             text: TextSpan(
              //               children: const [
              //                 WidgetSpan(
              //                   child: Icon(Icons.email, size: 14),
              //                 ),
              //                 TextSpan(
              //                     text: " Support Contact",
              //                     style: TextStyle(
              //                         color: Colors.black, fontSize: 12)),
              //               ],
              //             ),
              //           ),
              //           if (widget.profile.containsKey('email'))
              //             Text(
              //               widget.profile['email'],
              //               style: TextStyle(
              //                 fontSize: 16,
              //                 color: Colors.blue,
              //               ),
              //             ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

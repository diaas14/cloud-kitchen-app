import 'package:flutter/material.dart';

class FoodProviderProfile extends StatefulWidget {
  final Map<String, dynamic> profile;
  const FoodProviderProfile({super.key, required this.profile});

  @override
  State<FoodProviderProfile> createState() => _FoodProviderProfileState();
}

class _FoodProviderProfileState extends State<FoodProviderProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: widget.profile.containsKey("businessLogo")
                        ? Image.network(
                            widget.profile["businessLogo"],
                            width: 150,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/icons/kairuchi_icon.png',
                            width: 150,
                            height: 150,
                          ),
                  ),
                ),
                Text(
                  widget.profile['businessName'],
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 6.0),
                      child: Icon(
                        Icons.location_pin,
                        size: 18,
                        color: Color.fromARGB(190, 61, 135, 118),
                      ),
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
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
              child: Text(
                "Photos",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200, // Set a fixed height for the horizontal gallery
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.profile["businessPicsUrls"].length,
                itemBuilder: (context, index) {
                  final imageUrl = widget.profile["businessPicsUrls"][index];
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Image.network(
                      imageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

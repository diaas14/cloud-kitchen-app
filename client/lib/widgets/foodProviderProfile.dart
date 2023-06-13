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
    print(widget.profile);
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(190, 61, 135, 118),
      ),
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
          SizedBox(height: 8.0),
          Text(
            widget.profile['businessName'],
            style: TextStyle(
                fontSize: 24, color: Color.fromARGB(255, 218, 241, 230)),
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
                  color: Color.fromARGB(255, 218, 241, 230),
                ),
              ),
              Text(
                '${widget.profile['address']['street']}, ${widget.profile['address']['subLocality']}, ${widget.profile['address']['locality']}, ${widget.profile['address']['country']}',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 218, 241, 230),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

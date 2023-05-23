import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final Map<String, dynamic> profile;
  const Menu({super.key, required this.profile});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: widget.profile.containsKey("businessLogo")
                          ? Image.network(
                              widget.profile["businessLogo"],
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.profile['businessName'],
                            style: TextStyle(fontSize: 24)),
                        Text(
                          '${widget.profile['address']['street']}, ${widget.profile['address']['subLocality']}, ${widget.profile['address']['locality']}, ${widget.profile['address']['country']}',
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "Photos",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: const [
                        WidgetSpan(
                          child: Icon(
                            Icons.info,
                            size: 18,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        TextSpan(
                          text: " About",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          Text(widget.profile['email']),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

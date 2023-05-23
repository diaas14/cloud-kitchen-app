import 'package:flutter/material.dart';
import 'package:client/services/business_service.dart';
import 'package:client/pages/foodProvider.dart';

class FoodProviders extends StatefulWidget {
  const FoodProviders({Key? key}) : super(key: key);

  @override
  _FoodProvidersState createState() => _FoodProvidersState();
}

class _FoodProvidersState extends State<FoodProviders> {
  List<Map<String, dynamic>> _profiles = [];

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    _profiles = await fetchBusinessProfiles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _profiles.length,
      itemBuilder: (context, index) {
        final profile = _profiles[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FoodProvider(profile: profile)));
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profile.containsKey('businessName'))
                        Text(
                          profile['businessName'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (profile.containsKey('location'))
                        Text(
                          '${profile['address']['street']}, ${profile['address']['subLocality']}, ${profile['address']['locality']}, ${profile['address']['country']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: CircleAvatar(
                          radius: 22,
                          child: profile.containsKey("photoUrl")
                              ? ClipOval(
                                  child: Image.network(
                                    profile["photoUrl"],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : IconTheme(
                                  data: IconThemeData(
                                    size: 20,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: const [
                                  WidgetSpan(
                                    child: Icon(Icons.email, size: 14),
                                  ),
                                  TextSpan(
                                      text: " Support Contact",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                ],
                              ),
                            ),
                            if (profile.containsKey('email'))
                              Text(
                                profile['email'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

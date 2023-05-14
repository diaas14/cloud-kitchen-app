import 'package:flutter/material.dart';
import 'package:businessclient/services/profile_service.dart';
import 'package:businessclient/pages/editBusinessDetails.dart';
import 'package:businessclient/widgets/photosPicker.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  late Future<Map<String, dynamic>> _profileData;

  @override
  void initState() {
    super.initState();
    setState(() {
      _profileData = fetchServiceDetails();
    });
  }

  void updateProfileData() {
    setState(() {
      _profileData = fetchServiceDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _profileData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final profile = snapshot.data!;
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
                              child: ClipOval(
                                child: profile.containsKey("businessLogo")
                                    ? Image.network(
                                        profile["businessLogo"],
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
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile['businessName'],
                                  style: TextStyle(fontSize: 24)),
                              Text(
                                '${profile['address']['street']}, ${profile['address']['subLocality']}, ${profile['address']['locality']}, ${profile['address']['country']}',
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
                      if (!profile.containsKey('businessPicsUrls') ||
                          profile['businessPicsUrls'].isEmpty())
                        Text("Pics Not Available"),
                      PhotosPicker()
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Card(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Edit Business Details',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditBusinessDetails(
                              profile: profile,
                              onUpdateProfileData: updateProfileData,
                            )),
                  );
                },
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
                            child: profile.containsKey("photoUrl")
                                ? ClipOval(
                                    child: Image.network(
                                      profile["photoUrl"],
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
                                Text(profile['name'],
                                    style: TextStyle(fontSize: 24)),
                                Text(profile['email']),
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
        } else if (snapshot.hasError) {
          return Text('Error loading profile data');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

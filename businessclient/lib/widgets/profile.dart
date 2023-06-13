import 'package:businessclient/widgets/foodProviderProfile.dart';
import 'package:businessclient/widgets/imageGallery.dart';
import 'package:flutter/material.dart';
import 'package:businessclient/services/profile_service.dart';
import 'package:businessclient/pages/editBusinessDetails.dart';
import 'package:businessclient/widgets/photosPicker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
          return SingleChildScrollView(
            child: Column(
              children: [
                FoodProviderProfile(profile: profile),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 233, 249, 241),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: double.infinity,
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
                            imageUrls: (profile.containsKey("businessPicsUrls"))
                                ? profile["businessPicsUrls"]
                                : []),
                        PhotosPicker(
                          onPostClicked: updateProfileData,
                        ),
                      ]),
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
                                  SizedBox(height: 4),
                                  Text(
                                    profile['email'],
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
                SizedBox(
                  height: 80,
                ),
              ],
            ),
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

import 'package:client/models/user.dart';
import 'package:flutter/material.dart';
import 'package:client/services/profile_service.dart';
import 'package:client/pages/editProfile.dart';
import 'package:provider/provider.dart';

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
      _profileData = fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    print('State user data ${userProvider.userData}');
    return FutureBuilder<Map<String, dynamic>>(
      future: _profileData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final profile = snapshot.data!;
          return Container(
            child: Column(
              children: [
                Card(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircleAvatar(
                          radius: 60,
                          child: profile.containsKey("photoUrl")
                              ? ClipOval(
                                  child: Image.network(
                                    profile["photoUrl"],
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : IconTheme(
                                  data: IconThemeData(
                                    size: 55,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                  ),
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
                            ElevatedButton(
                              child: RichText(
                                text: TextSpan(
                                  children: const [
                                    TextSpan(text: "Edit "),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfile(profile: profile)),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
      // ),
    );
  }
}

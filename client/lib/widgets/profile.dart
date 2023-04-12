import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:client/services/auth_service.dart';

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
    _profileData = fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
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
                                    fit: BoxFit.cover,
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text("Logout"),
                  onPressed: () async {
                    if (await GoogleSignIn().isSignedIn()) {
                      await GoogleSignIn().signOut();
                    }
                    FirebaseAuth.instance.signOut();
                  },
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

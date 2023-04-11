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
                Text(profile['name']),
                Text(profile['email']),
                if (profile.containsKey("photoUrl"))
                  Image.network(profile["photoUrl"]),
                ElevatedButton(
                  child: Text("Logout"),
                  onPressed: () async {
                    if (await GoogleSignIn().isSignedIn()) {
                      await GoogleSignIn().signOut();
                    }
                    FirebaseAuth.instance.signOut();
                  },
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error loading profile data');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

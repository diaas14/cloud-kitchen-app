import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Stack(
          children: [
            ClipPath(
              clipper: BottomSkewClipper(),
              child: Container(
                height: height / 2,
                // color: Color.fromARGB(188, 50, 147, 124),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1, -1),
                    end: Alignment(1, 0.75),
                    colors: <Color>[
                      Color.fromARGB(188, 50, 147, 124),
                      Color.fromARGB(255, 193, 255, 236),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: (width - width / 1.5) / 2, // Center the image horizontally
              bottom: 0, // Align the image at the bottom of the green container
              child: Image.asset(
                'assets/images/dosa_illustration.png', // Replace with your own image URL
                width: width / 1.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 35, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Cabin',
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Kairuchi',
                    style: TextStyle(
                      fontSize: 64,
                      fontFamily: 'Cabin',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Locate and purchase home-cooked healthy meals from small-scale, regional food providers in your neighborhood!',
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Explore",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Empty space for the scrollable content below
      ],
    );
  }
}

class BottomSkewClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

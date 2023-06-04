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
                color: Color.fromARGB(190, 122, 209, 188),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                    child: Text(
                      'Welcome to Kairuchi Business',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      'Locate and purchase home-cooked healthy meals from small-scale, regional food providers in your neighborhood!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
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
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

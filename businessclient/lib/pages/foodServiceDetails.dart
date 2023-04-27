import 'package:flutter/material.dart';

class FoodServiceDetails extends StatefulWidget {
  const FoodServiceDetails({super.key});

  @override
  State<FoodServiceDetails> createState() => _FoodServiceDetailsState();
}

class _FoodServiceDetailsState extends State<FoodServiceDetails> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1, -1),
            end: Alignment(1, 1),
            colors: <Color>[
              Theme.of(context).backgroundColor,
              Color.fromARGB(190, 255, 255, 255)
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/images/idli_illustration.png',
                  width: width / (1.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:businessclient/services/location_service.dart';
import 'package:businessclient/services/profile_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:businessclient/pages/home.dart';
import 'package:geolocator/geolocator.dart';

class FoodServiceDetails extends StatefulWidget {
  const FoodServiceDetails({super.key});

  @override
  State<FoodServiceDetails> createState() => _FoodServiceDetailsState();
}

class _FoodServiceDetailsState extends State<FoodServiceDetails> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Placemark? place;
  Position? position;
  bool isLoading = false;

  void _submitHandler(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final result = await saveServiceDetails(name, position);
      Fluttertoast.showToast(
        msg: result,
      );
      if (result == 'success' && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    }
  }

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
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(24, 64, 24, 64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: Text(
                      "Tell us about your Services",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 40, bottom: 20),
                          padding: EdgeInsets.fromLTRB(15, 30, 15, 15),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    validator: ((value) {
                                      return null;
                                    }),
                                    cursorColor:
                                        Color.fromARGB(255, 21, 120, 131),
                                    decoration: InputDecoration(
                                      labelText: "Services' Name*",
                                      labelStyle: TextStyle(
                                        fontSize: 17,
                                        color:
                                            Color.fromARGB(255, 21, 120, 131),
                                      ),
                                      hintText: "Enter your Services' Name",
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 21, 120, 131),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 21, 120, 131),
                                        ),
                                      ),
                                    ),
                                    controller: _nameController,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton.icon(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      position = await determinePosition();
                                      place = await determinePlace(position);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.room_rounded,
                                      color: Color.fromARGB(255, 21, 120, 131),
                                    ),
                                    label: Text(
                                      isLoading
                                          ? 'Loading Location'
                                          : place != null
                                              ? 'Change Location'
                                              : 'Pick current Location',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromARGB(255, 21, 120, 131),
                                      ),
                                    ),
                                  ),
                                ),
                                if (isLoading)
                                  Transform.scale(
                                    scale: 0.75,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                if (!isLoading && place?.country != null)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 16.0),
                                      child: Text(
                                        '${place?.street}, ${place?.subLocality}, ${place?.locality}, ${place?.country}',
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    _submitHandler(context);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Image.asset(
                            'assets/icons/kairuchi_icon.png',
                            width: 80.0,
                            height: 80.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    icon: const Icon(Icons.arrow_right,
                        color: Color.fromARGB(255, 21, 120, 131)),
                    label: const Text(
                      "Skip for now",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 21, 120, 131),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

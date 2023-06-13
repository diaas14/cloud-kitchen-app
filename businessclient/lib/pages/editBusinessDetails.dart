import 'dart:io';

import 'package:businessclient/services/location_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:businessclient/services/profile_service.dart';

import '../widgets/mapInterface.dart';

class EditBusinessDetails extends StatefulWidget {
  final Map<String, dynamic> profile;
  final Function onUpdateProfileData;
  const EditBusinessDetails(
      {super.key, required this.profile, required this.onUpdateProfileData});

  @override
  State<EditBusinessDetails> createState() => _EditBusinessDetailsState();
}

class _EditBusinessDetailsState extends State<EditBusinessDetails> {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isbusinessNameChanged = false;
  bool isLocationChanged = false;
  Future<Position> currentLocation = fetchPosition();
  late String _addressDetails;
  late Placemark updatedPlace;
  XFile? _imageFile;
  // late GeoPoint geoPoint = GeoPoint.fromMap(widget.profile['location']);
  late Position posFromProfile = Position(
      longitude: widget.profile['location']['_longitude'],
      latitude: widget.profile['location']['_latitude'],
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  Future _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Image picker error $e");
    }
  }

  _submitForm() async {
    final data = <String, dynamic>{};

    if (_businessNameController.text.trim() != widget.profile['businessName']) {
      data['businessName'] = _businessNameController.text.trim();
    }

    if (isLocationChanged) {
      Position currentPos = await Future.value(currentLocation);
      data['position'] = currentPos;
      data['place'] = updatedPlace;
    }

    if (data.isNotEmpty || _imageFile != null) {
      final res = await updateBusinessData(data, _imageFile);
      Fluttertoast.showToast(msg: res);

      if (res == 'success' && mounted) {
        widget.onUpdateProfileData();
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _addressDetails = widget.profile['address']['street'] +
            ", " +
            widget.profile['address']['subLocality'] +
            ", " +
            widget.profile['address']['locality'] +
            ", " +
            widget.profile['address']['country'] ??
        '';
    _businessNameController.text = widget.profile['businessName'] ?? '';
    _locationController.text = _addressDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(190, 61, 135, 118),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  child: (_imageFile != null)
                      ? ClipOval(
                          child: Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.profile.containsKey("businessLogoUrl")
                          ? ClipOval(
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(
                                      0.5), // Adjust opacity as needed
                                  BlendMode.darken,
                                ),
                                child: Image.network(
                                  widget.profile["businessLogoUrl"],
                                  fit: BoxFit.cover,
                                ),
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
                IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: _pickImage,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x7fffffff),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(children: [
                TextFormField(
                  validator: ((value) {
                    return null;
                  }),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Business\' Name',
                    hintText: 'Enter your Business\' Name',
                  ),
                  controller: _businessNameController,
                  onChanged: (value) {
                    setState(() {
                      _isbusinessNameChanged =
                          value.trim() != widget.profile["businessName"];
                    });
                  },
                ),
                TextFormField(
                    validator: ((value) {
                      return null;
                    }),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Business\' Location',
                      hintText: 'Enter your Business\' Location',
                    ),
                    controller: _locationController,
                    onTap: () async {
                      var selectedLocation = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  GoogleMapsUI(posFromProfile)));
                      var selectedPlace =
                          await determinePlace(selectedLocation);
                      setState(() {
                        updatedPlace = selectedPlace;
                        currentLocation = Future.value(selectedLocation);
                        _locationController.text =
                            "${updatedPlace.street}, ${updatedPlace.subLocality}, ${updatedPlace.locality}, ${updatedPlace.country}";
                        if (_locationController.text.trim() !=
                            _addressDetails) {
                          isLocationChanged = true;
                        }
                      });
                    })
              ]),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: _imageFile != null ||
                      _isbusinessNameChanged ||
                      isLocationChanged
                  ? _submitForm
                  : null,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

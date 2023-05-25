import 'dart:convert';
import 'package:businessclient/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'dart:async';

late Position posFromProfile;

class GoogleMapsUI extends StatefulWidget {
  final Position location;
  GoogleMapsUI(this.location, {super.key}) {
    posFromProfile = location;
  }

  @override
  State<GoogleMapsUI> createState() => GoogleMapsUIState();
}

class GoogleMapsUIState extends State<GoogleMapsUI> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<Position> currentLocation = Future.value(posFromProfile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Position>(
          future: currentLocation,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              Position position = snapshot.data;
              return Stack(children: [
                GoogleMap(
                  onTap: (LatLng pickedLocation) {
                    changeLocation(context, pickedLocation, position);
                  },
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 15.0),
                  mapToolbarEnabled: false,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: <Marker>{
                    Marker(
                      markerId: MarkerId('currentLocationMarker'),
                      position: LatLng(position.latitude, position.longitude),
                    ),
                  },
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(currentLocation);
                    },
                    child: Text('OK'),
                  ),
                ),
              ]);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  void changeLocation(
      BuildContext context, LatLng pickedLocation, Position currentPos) async {
    Position updatedLocation = Position(
        longitude: pickedLocation.longitude,
        latitude: pickedLocation.latitude,
        timestamp: currentPos.timestamp,
        accuracy: currentPos.accuracy,
        altitude: currentPos.altitude,
        heading: currentPos.heading,
        speed: currentPos.speed,
        speedAccuracy: currentPos.speedAccuracy);
    Placemark updatedPlace = await determinePlace(updatedLocation);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return confirmationAlert(updatedPlace, context, updatedLocation);
      },
    );
  }

  AlertDialog confirmationAlert(
      Placemark updatedPlace, BuildContext context, Position updatedLocation) {
    return AlertDialog(
      title: Row(children: const [
        Icon(Icons.edit_location_sharp),
        SizedBox(
          width: 6,
        ),
        Text(
          'Confirm new location',
          style: TextStyle(color: Color.fromARGB(255, 21, 120, 131)),
        )
      ]),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Are you sure you want to move to this location?'),
          Text(
            '${updatedPlace.name}, ${updatedPlace.street}, ${updatedPlace.subLocality}, ${updatedPlace.locality}, ${updatedPlace.country}',
            style: TextStyle(fontStyle: FontStyle.italic),
          )
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            'CANCEL',
            style: TextStyle(color: Colors.black45),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('YES',
              style: TextStyle(color: Color.fromARGB(255, 21, 120, 131))),
          onPressed: () {
            setState(() {
              currentLocation = Future.value(updatedLocation);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

Future<Position> fetchPosition() async {
  // var lat = loc['latitude'];
  // var lng = loc['longitude'];
  // String bname = profileObject['businessName'];
  // print(bname);
  // print(profileObject['location'].longitude);
  // return locationObject;
  return await determinePosition();
}

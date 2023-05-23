import 'package:client/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'dart:async';

class MapInterface extends StatefulWidget {
  const MapInterface({super.key});

  @override
  State<MapInterface> createState() => MapInterfaceState();
}

class MapInterfaceState extends State<MapInterface> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<Position> currentLocation = fetchPosition();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Position>(
          future: currentLocation,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              Position position = snapshot.data;
              return GoogleMap(
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
              );
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
}

Future<Position> fetchPosition() async {
  return await determinePosition();
}

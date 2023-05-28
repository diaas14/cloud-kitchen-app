import 'package:client/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'dart:async';

import '../pages/foodProvider.dart';
import '../services/business_service.dart';

class MapInterface extends StatefulWidget {
  const MapInterface({super.key});

  @override
  State<MapInterface> createState() => MapInterfaceState();
}

class MapInterfaceState extends State<MapInterface> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  List<Marker> markers = [];

  List<Map<String, dynamic>> _profiles = [];
  Map<Map<String, Position>, Map<String, Map<String, dynamic>>>
      foodProvidersInfo = {};
  late Future<Position> currentLocation = fetchPosition();

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    _profiles = await fetchBusinessProfiles();
    for (var profile in _profiles) {
      if (profile.containsKey("location") &&
          profile.containsKey("businessName")) {
        Map<String, Position> markerRelatedInfo = {
          "${profile['businessName']}": Position(
              longitude: profile['location']['_longitude'],
              latitude: profile['location']['_latitude'],
              timestamp: DateTime.now(),
              accuracy: 0.0,
              altitude: 0.0,
              heading: 0.0,
              speed: 0.0,
              speedAccuracy: 0.0)
        };
        Map<String, Map<String, dynamic>> foodProviderNavigationInfo = {
          profile['userId']: profile
        };
        foodProvidersInfo.putIfAbsent(
            markerRelatedInfo, () => foodProviderNavigationInfo);
      }
    }
    markers = await addMarkers(_profiles);
  }

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
                  markers: Set.of(markers));
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

  Future<Position> fetchPosition() async {
    return await determinePosition();
  }

  Future<List<Marker>> addMarkers(List<Map<String, dynamic>> profiles) async {
    Position position = await determinePosition();
    List<Marker> markersToDisplay = [];
    markersToDisplay.add(
      Marker(
          markerId: MarkerId('currentLocationMarker'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: "You are here")),
    );

    var radius = 1000;
    foodProvidersInfo.forEach((markerRelatedInfo, foodProviderNavigationInfo) {
      markerRelatedInfo.forEach((providerName, providerLocation) {
        foodProviderNavigationInfo.forEach((providerID, providerProfile) {
          double distance = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              providerLocation.latitude,
              providerLocation.longitude);
          if (distance <= radius) {
            markersToDisplay.add(Marker(
                markerId: MarkerId(providerLocation.toString()),
                position: LatLng(
                    providerLocation.latitude, providerLocation.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
                infoWindow: InfoWindow(title: providerName),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodProvider(
                              profile: providerProfile,
                              providerId: providerID)),
                    )));
          } else {
            markersToDisplay.add(Marker(
                markerId: MarkerId(providerLocation.toString()),
                position: LatLng(
                    providerLocation.latitude, providerLocation.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueOrange),
                infoWindow: InfoWindow(title: providerName),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodProvider(
                              profile: providerProfile,
                              providerId: providerID)),
                    )));
          }
          setState(() {});
        });
      });
    });

    return markersToDisplay;
  }
}

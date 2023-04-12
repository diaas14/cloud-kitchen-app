import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:client/services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Future<Placemark> _currentPlace;

  @override
  void initState() {
    super.initState();
    _currentPlace = determinePlace();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Placemark>(
        future: _currentPlace,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Placemark place = snapshot.data!;
            return Text(
                '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country},');
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

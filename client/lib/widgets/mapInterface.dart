import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:client/services/location_service.dart';

class MapInterface extends StatefulWidget {
  const MapInterface({super.key});

  @override
  State<MapInterface> createState() => _MapInterfaceState();
}

class _MapInterfaceState extends State<MapInterface> {
  late Future<Placemark> _currentPlace;

  @override
  void initState() {
    super.initState();
    _currentPlace = determineCurrentPlace();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Placemark>(
        future: _currentPlace,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Placemark place = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Your current location',
                    style: TextStyle(
                        letterSpacing: 1.2,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}',
                          style: TextStyle(
                              letterSpacing: 1.2,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Position?> retrievePositionDataFromStorage() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final latitude = sharedPreferences.getDouble('currentLatitude');
  final longitude = sharedPreferences.getDouble('currentLongitude');
  if (latitude != null && longitude != null) {
    final positionMap = {
      'latitude': latitude,
      'longitude': longitude,
    };
    return Position.fromMap(positionMap);
  }
  return null;
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

Future<Placemark> determineCurrentPlace() async {
  Position position = await determinePosition();
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  return placemarks[0];
}

Future<Placemark> determinePlace(Position position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  return placemarks[0];
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371;
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;
  return distance;
}

double _toRadians(double degree) {
  return degree * pi / 180;
}

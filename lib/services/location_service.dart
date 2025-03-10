import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationService {
  static Future<LatLng?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied.");
    }

    Position position = await Geolocator.getCurrentPosition();
    return LatLng(position.latitude, position.longitude);
  }

  static Future<List<LatLng>> fetchRoute(
      LatLng start, LatLng destination) async {
    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> coordinates =
        data['routes'][0]['geometry']['coordinates'];

        return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      } else {
        throw Exception("Failed to fetch route.");
      }
    } catch (e) {
      throw Exception("Error fetching route: $e");
    }
  }
}
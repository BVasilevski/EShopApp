import 'dart:convert';
import 'package:e_shop_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../services/location_service.dart';
import '../widgets/navigation.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _selectedIndex = 0;
  LatLng? _userLocation;
  List<LatLng> _routePoints = [];
  final LatLng _destination =
  const LatLng(42.00415082962822, 21.409493539235406);

  void _onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/items');
        break;
      case 1:
        Navigator.pushNamed(context, '/cart');
        break;
      case 2:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  Future<void> _getUserLocation() async {
    try {
      LatLng? location = await LocationService.getUserLocation();
      if (location != null) {
        setState(() {
          _userLocation = location;
        });

        _fetchRoute();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _fetchRoute() async {
    if (_userLocation == null) return;

    try {
      List<LatLng> route =
      await LocationService.fetchRoute(_userLocation!, _destination);
      setState(() {
        _routePoints = route;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Route fetched successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthHelper.checkLoginStatus(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(42.00415082962822, 21.409493539235406),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                // Keep original marker
                const MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(42.00415082962822, 21.409493539235406),
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                if (_userLocation != null)
                  MarkerLayer(
                    markers: [
                      // User location marker
                      Marker(
                        point: _userLocation!,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        color: Colors.blue,
                        strokeWidth: 5.0,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: ElevatedButton(
                onPressed: _getUserLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Go',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          NavigationWidget(
            selectedIndex: _selectedIndex,
            onIndexChanged: _onIndexChanged,
          ),
        ],
      ),
    );
  }
}

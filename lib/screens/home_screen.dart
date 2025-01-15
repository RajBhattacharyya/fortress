import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  double? phoneLatitude;
  double? phoneLongitude;
  double? targetLatitude;
  double? targetLongitude;
  int? statusud;
  double? distance;

  final databaseReference = FirebaseDatabase.instance.ref();
  StreamSubscription<LocationData>? _locationSubscription;
  StreamSubscription<DatabaseEvent>? _statusSubscription;
  StreamSubscription<DatabaseEvent>? _latitudeSubscription;
  StreamSubscription<DatabaseEvent>? _longitudeSubscription;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
    _setupFirebaseListeners();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _statusSubscription?.cancel();
    _latitudeSubscription?.cancel();
    _longitudeSubscription?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        phoneLatitude = currentLocation.latitude;
        phoneLongitude = currentLocation.longitude;

        if (targetLatitude != null && targetLongitude != null) {
          distance = _calculateDistance(phoneLatitude!, phoneLongitude!,
              targetLatitude!, targetLongitude!);
        }

        // Optionally update the phone's location in Firebase
        databaseReference.child('lat').set(phoneLatitude);
        databaseReference.child('long').set(phoneLongitude);
      });
    });
  }

  void _setupFirebaseListeners() {
    final latitudeRef = databaseReference.child('lats');
    final longitudeRef = databaseReference.child('longs');
    final statusudRef = databaseReference.child('statusd');

    _latitudeSubscription = latitudeRef.onValue.listen((DatabaseEvent event) {
      final latitude = double.tryParse(event.snapshot.value.toString());
      setState(() {
        targetLatitude = latitude;

        if (phoneLatitude != null && phoneLongitude != null) {
          distance = _calculateDistance(phoneLatitude!, phoneLongitude!,
              targetLatitude!, targetLongitude!);
        }
      });
    });

    _longitudeSubscription = longitudeRef.onValue.listen((DatabaseEvent event) {
      final longitude = double.tryParse(event.snapshot.value.toString());
      setState(() {
        targetLongitude = longitude;

        if (phoneLatitude != null && phoneLongitude != null) {
          distance = _calculateDistance(phoneLatitude!, phoneLongitude!,
              targetLatitude!, targetLongitude!);
        }
      });
    });

    _statusSubscription = statusudRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        statusud = int.tryParse(event.snapshot.value.toString());
      });
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // Earth radius in meters
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c / 1000; // Distance in kilometers
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Status',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: statusud == 1
                        ? Colors.red.withOpacity(0.7)
                        : Colors.green.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    statusud == 1 ? 'Locked' : 'Unlocked',
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone Latitude: ${phoneLatitude ?? "Loading..."}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Phone Longitude: ${phoneLongitude ?? "Loading..."}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Home's Latitude: ${targetLatitude ?? "Loading..."}",
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Home's Longitude: ${targetLongitude ?? "Loading..."}",
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Distance: ${distance?.toStringAsFixed(2) ?? "Calculating..."} km',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

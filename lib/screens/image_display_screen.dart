import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageDisplayScreen extends StatefulWidget {
  const ImageDisplayScreen({super.key});

  @override
  State<ImageDisplayScreen> createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('image');
  String? _image64;

  @override
  void initState() {
    super.initState();
    _setupDatabaseListener();
  }

  void _setupDatabaseListener() {
    _databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as String?;
      setState(() {
        _image64 = data?.isNotEmpty == true ? data : null;
      });
    });
  }

  void _makeSOSCall() async {
    if (await Permission.phone.request().isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: '100');
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $phoneUri';
      }
    } else {
      throw 'Phone permission not granted';
    }
  }

  Uint8List? _getDecodedImage() {
    if (_image64 == null) return null;
    try {
      return base64Decode(_image64!);
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final decodedImage = _getDecodedImage();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Intruder Image',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _image64 == null
                    ? Colors.green.withOpacity(0.7)
                    : Colors.red.withOpacity(0.7),
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
                _image64 == null ? 'No Intruder Detected' : 'Intruder Detected',
                style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: _image64 == null
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: 300,
                      width: 350,
                      child: Card(
                        color: Colors.white.withOpacity(0.8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: decodedImage == null
                              ? const Center(
                                  child: Text(
                                    'Failed to Load Image',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              : Image.memory(
                                  decodedImage,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 50),
            _image64 != null
                ? ElevatedButton(
                    onPressed: _makeSOSCall,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'SOS - Call 100',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  final List<Map<String, dynamic>> _userImages = [];
  bool _isLoading = true; // Fix initialization
  bool _isSaving = false;
  int? _selectedIndex;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Images')
          .doc('users') // Replace with the document ID
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        final base64List = data['base64'] as List<dynamic>;

        setState(() {
          _userImages.clear();
          for (var item in base64List) {
            item.forEach((key, value) {
              _userImages.add({'name': key, 'base64_images': value});
            });
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserName(int index) async {
    setState(() {
      _isSaving = true;
    });

    try {
      final updatedName = _nameController.text;
      final user = _userImages[index];

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('Images')
          .doc('users') // Replace with the document ID
          .update({
        'base64': FieldValue.arrayRemove([
          {user['name']: user['base64_images']}
        ])
      });

      await FirebaseFirestore.instance
          .collection('Images')
          .doc('users') // Replace with the document ID
          .update({
        'base64': FieldValue.arrayUnion([
          {updatedName: user['base64_images']}
        ])
      });

      // Update local state
      setState(() {
        _userImages[index]['name'] = updatedName;
        _selectedIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User name updated successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user name: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Users',
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _userImages.isEmpty
                ? const Center(
                    child: Text(
                      'No users found.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: _userImages.length,
                    itemBuilder: (context, index) {
                      final user = _userImages[index];
                      final base64Images = user['base64_images'] as String;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 199, 199, 199)
                                  .withOpacity(0.8),
                              const Color.fromARGB(255, 50, 50, 50)
                                  .withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: base64Images.isNotEmpty
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage: MemoryImage(
                                          base64Decode(base64Images),
                                        ),
                                      )
                                    : const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                title: Text(
                                  user['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = _selectedIndex == index
                                          ? null
                                          : index;
                                      _nameController.text = user['name'];
                                    });
                                  },
                                ),
                              ),
                              if (_selectedIndex == index &&
                                  base64Images.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Name',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _isSaving
                                            ? null
                                            : () => _saveUserName(index),
                                        child: _isSaving
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text('Save'),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

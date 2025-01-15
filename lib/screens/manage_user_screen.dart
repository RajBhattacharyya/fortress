import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  List<Map<String, dynamic>> _userImages = [];
  bool _isLoading = true;
  int? _selectedIndex;
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _newImage;

  @override
  void initState() {
    super.initState();
    _fetchUserImages();
  }

  Future<void> _fetchUserImages() async {
    try {
      final ListResult result =
          await FirebaseStorage.instance.ref().child('users/').listAll();

      final List<Map<String, dynamic>> userImages = await Future.wait(
        result.items.map((Reference ref) async {
          final String downloadUrl = await ref.getDownloadURL();
          final String fileName =
              ref.name.split('.').first; // Assuming file name is the user name

          return {
            'name': fileName,
            'image_url': downloadUrl,
          };
        }).toList(),
      );

      setState(() {
        _userImages = userImages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch images: $e')),
      );
    }
  }

  Future<void> _deleteUserImage(String imageName) async {
    try {
      final storageReference =
          FirebaseStorage.instance.ref().child('users/$imageName.jpg');
      await storageReference.delete();

      setState(() {
        _userImages.removeWhere((user) => user['name'] == imageName);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image $imageName deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete image: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _clickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUserImage(int index) async {
    final userImage = _userImages[index];
    String newName = _nameController.text.trim();
    String currentName = userImage['name'];

    bool nameChanged = newName.isNotEmpty && newName != currentName;
    bool imageChanged = _newImage != null;

    if (!nameChanged && !imageChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes made')),
      );
      return;
    }

    try {
      if (imageChanged) {
        // Handle image update
        final storageReference =
            FirebaseStorage.instance.ref().child('users/$newName.jpg');
        final uploadTask = storageReference.putFile(_newImage!);
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _userImages[index]['image_url'] = downloadUrl;
          if (nameChanged) {
            _userImages[index]['name'] = newName;
          }
        });

        if (nameChanged) {
          await FirebaseStorage.instance
              .ref()
              .child('users/$currentName.jpg')
              .delete();
        }
      } else if (nameChanged) {
        // Handle name change only
        // Download the current image
        final currentImageRef =
            FirebaseStorage.instance.ref().child('users/$currentName.jpg');
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$currentName.jpg');

        // Download the current image to the temporary file
        await currentImageRef.writeToFile(tempFile);

        // Upload the image with the new name
        final newImageRef =
            FirebaseStorage.instance.ref().child('users/$newName.jpg');
        final uploadTask = newImageRef.putFile(tempFile);
        await uploadTask.whenComplete(() {});
        final downloadUrl = await newImageRef.getDownloadURL();

        setState(() {
          _userImages[index]['image_url'] = downloadUrl;
          _userImages[index]['name'] = newName;
        });

        // Delete the old image
        await currentImageRef.delete();

        // Remove the temporary file
        await tempFile.delete();
      } else {
        setState(() {
          _userImages[index]['name'] = newName;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully')),
      );
      setState(() {
        _selectedIndex = null;
        _newImage = null;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
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
                      final userImage = _userImages[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 199, 199, 199)
                                  .withOpacity(0.8),
                              const Color.fromARGB(255, 50, 50, 50)
                                  .withOpacity(0.6)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 29, 29, 29)
                                  .withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(userImage['image_url']),
                                  backgroundColor: Colors.grey[200],
                                ),
                                title: Text(
                                  userImage['name'],
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
                                      _nameController.text = userImage['name'];
                                      _newImage = null;
                                    });
                                  },
                                ),
                              ),
                              if (_selectedIndex == index)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Change Name',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 15),
                                      if (_newImage != null)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.file(
                                            _newImage!,
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _pickImage,
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.blue,
                                              ),
                                              child:
                                                  const Text('Pick New Image'),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _clickImage,
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.blue,
                                              ),
                                              child:
                                                  const Text('Capture Image'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  _updateUserImage(index),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.green,
                                              ),
                                              child: const Text('Update User'),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () => _deleteUserImage(
                                                _userImages[index]['name'],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: Colors.red,
                                              ),
                                              child: const Text('Delete User'),
                                            ),
                                          ),
                                        ],
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

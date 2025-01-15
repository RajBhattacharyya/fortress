import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortress/screens/auth_screen.dart';
import 'package:fortress/screens/home_screen.dart';
import 'package:fortress/screens/image_display_screen.dart';
import 'package:fortress/screens/manage_user_screen.dart';
import 'package:fortress/screens/upload_image_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      const HomeScreen(),
      const UploadImageScreen(),
      const ImageDisplayScreen(),
      const ManageUserScreen(),
    ];

    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(1),
        shape: const CircleBorder(),
        backgroundColor: const Color.fromRGBO(237, 237, 240, 1),
        foregroundColor: const Color.fromRGBO(55, 53, 53, 1),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: const Color.fromRGBO(55, 53, 53, 1),
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(
                _selectedIndex == 2 ? Icons.error : Icons.error_outline,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(2),
            ),
            const SizedBox(width: 1),
            IconButton(
              icon: Icon(
                _selectedIndex == 3 ? Icons.people : Icons.people_outline,
                color: Colors.white,
              ),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: screens[_selectedIndex],
    );
  }
}

import 'package:a3certify/screens/home_page.dart';
import 'package:a3certify/screens/notfications.dart';
import 'package:a3certify/settingnav/setting_page.dart';
import 'package:flutter/material.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  final List<Widget> _pages= const [
    HomePage(),
    Notifications(),
    Profile(),
  ];
  int x = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
        selectedItemColor: const Color.fromRGBO(57, 88, 134, 1.0),
        unselectedItemColor: Colors.black,
        currentIndex: x,
        onTap: (index) {
          setState(() {

          });
          x = index;
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
            Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Notifications',
            icon: Icon(
            Icons.notifications,
          ),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
            Icons.settings,
          ),)
        ],
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(213, 222, 239, 1.0),
      ),
      body: _pages[x],
    );
  }
}

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:insight/body/bottom_bar/profile.dart';
//import 'package:insight/intro/auth_service.dart';
import 'package:insight/body/bottom_bar/profile.dart';
import 'package:insight/body/bottom_bar/favorite.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  final Color _selectedColor = const Color.fromARGB(255, 10, 186, 180);

  final List<Map<String, dynamic>> _pages = [
    {
      'page': const Center(
          child: Text('Home Content', style: TextStyle(fontSize: 24))),
      'title': 'Home',
    },
    {
      'page': Favorite(),
      'title': 'Favorite Projects',
    },
    {
      'page': Profile(),
      'title': 'Profile',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_pages[_selectedIndex]['title']),
        backgroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: _buildBar(),
    );
  }

  Widget _buildBar() {
    return CurvedNavigationBar(
      animationDuration: Duration(milliseconds: 200),
      backgroundColor: Colors.white,
      color: _selectedColor,
      buttonBackgroundColor: _selectedColor,
      height: 60,
      index: _selectedIndex,
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.favorite, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
      onTap: _onItemTapped,
    );
  }
}

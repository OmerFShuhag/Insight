import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:insight/body/bottom_bar/profile.dart';
import 'package:insight/intro/auth_service.dart';
import 'package:insight/body/bottom_bar/profile.dart';
import 'package:insight/body/bottom_bar/favorite.dart';
import 'package:insight/body/bottom_bar/dashboard.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  final Color _selectedColor = const Color.fromARGB(255, 10, 186, 180);

  final List<Map<String, dynamic>> _pages = [
    {
      'page': Dashboard(),
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
        title: Text(
          _pages[_selectedIndex]['title'],
          style: TextStyle(
            fontSize: 24,
            color: const Color.fromARGB(255, 243, 243, 243),
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        backgroundColor: _selectedColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _openSettingsMenu(context);
            },
            color: Colors.white,
          ),
        ],
        elevation: 5,
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
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.favorite, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
      onTap: _onItemTapped,
    );
  }

  void _openSettingsMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 50, 0, 0),
      items: [
        PopupMenuItem<String>(
          value: 'SignOut',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () {
              Navigator.of(context).pop(); // Close the menu
              AuthService().signout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ),
      ],
    );
  }
}

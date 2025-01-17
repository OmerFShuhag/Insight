import 'package:flutter/material.dart';
import 'package:insight/intro/auth_service.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            AuthService().signout();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}

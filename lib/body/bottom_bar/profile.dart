import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _name = 'Loading...';
  String _email = 'Loading...';
  String _phone = 'Loading...';
  String _ID = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    // Simulate fetching data
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _name = "John Doe";
        _email = "john.doe@example.com";
        _phone = "+1234567890";
        _ID = "1234567890";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: $_name',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Email: $_email',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Phone: $_phone',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'ID: $_ID',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

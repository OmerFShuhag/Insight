import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insight/intro/login.dart';
import 'package:insight/intro/profile_setup.dart';
import 'package:insight/user_class.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    // Handle authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<DocumentSnapshot>(
        stream: userId != null
            ? FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading profile'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Profile not found'));
          }

          final user =
              User_class.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileField('Name', user.name),
              SizedBox(height: 10),
              _buildProfileField('ID', user.id),
              SizedBox(height: 10),
              _buildProfileField('Semester', user.semester),
              SizedBox(height: 10),
              _buildProfileField('Year', user.year.toString()),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileSetup()),
                  );
                },
                child: Text('Edit Profile'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            value.isEmpty ? "Not set" : value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

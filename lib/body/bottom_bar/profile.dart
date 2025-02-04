// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insight/intro/login.dart';
import 'package:insight/intro/profile_setup.dart';
import 'package:insight/user_class.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading profile'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Profile not found'));
          }

          final user =
              User_class.fromMap(snapshot.data!.data() as Map<String, dynamic>);

          return Column(
            children: [
              _buildProfileField('Name', user.name),
              const SizedBox(height: 10),
              _buildProfileField('ID', user.id),
              const SizedBox(height: 10),
              _buildProfileField('Batch', user.batch.toString()),
              const SizedBox(height: 10),
              _buildProfileField('Semester', user.semester),
              const SizedBox(height: 10),
              _buildProfileField('Year', user.year.toString()),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color(0xFF0ABAB5)), // Button color
                    foregroundColor:
                        WidgetStateProperty.all(Colors.white), // Text color
                    textStyle: WidgetStateProperty.all(
                      const TextStyle(
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileSetup()),
                    );
                  },
                  child: const Text('Edit Profile'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          Text(
            value.isEmpty ? "Not set" : value,
            style: const TextStyle(
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

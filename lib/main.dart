// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insight/body/homepage.dart';
import 'package:insight/intro/SignUpPage.dart';
import 'package:insight/intro/auth_service.dart';
import 'package:insight/intro/login.dart';
import 'package:insight/intro/forget_password_page.dart';
import 'package:insight/intro/profile_setup.dart';
import 'package:provider/provider.dart';
import 'package:insight/body/databseViewModel.dart';
import 'intro/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(ChangeNotifierProvider(
    create: (context) => ProjectViewModel(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: AuthService().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Center(child: Text('No connection'));
            } else if (snapshot.connectionState == ConnectionState.active) {
              final user = snapshot.data;
              if (user != null) {
                if (!user.emailVerified) {
                  return Login();
                } else {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get(),
                    builder: (context, profileSnapshot) {
                      if (profileSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (profileSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${profileSnapshot.error}'));
                      } else if (profileSnapshot.hasData &&
                          profileSnapshot.data != null &&
                          profileSnapshot.data!.exists) {
                        return Homepage();
                      } else {
                        return ProfileSetup();
                      }
                    },
                  );
                }
              } else {
                return Login();
              }
            } else {
              return const Center(child: Text("Unknown state"));
            }
          },
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => OnBoardingScreen(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUpPage(),
        '/forgetPassword': (context) => ForgetPassword(),
        '/homepage': (context) => Homepage(),
        '/profileSetup': (context) => ProfileSetup(),
      },
    );
  }
}

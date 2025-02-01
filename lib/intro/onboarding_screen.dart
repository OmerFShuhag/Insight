import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:insight/intro_screens/intro_page_1.dart';
import 'package:insight/intro_screens/intro_page_2.dart';
import 'package:insight/intro_screens/intro_page_3.dart';
import 'package:insight/main.dart';
import 'package:insight/intro/profile_setup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: Text('Skip'),
                ),
                SmoothPageIndicator(controller: _controller, count: 3),
                onLastPage
                    ? GestureDetector(
                  onTap: () {
                    _checkAuthState(context); // Use _checkAuthState here
                  },
                  child: Text('Done'),
                )
                    : GestureDetector(
                  onTap: () {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _checkAuthState(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      final isProfileSet = await _isProfileSet(user.uid);
      if (isProfileSet) {
        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
        Navigator.pushReplacementNamed(context, '/profileSetup');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<bool> _isProfileSet(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.exists;
  }
}
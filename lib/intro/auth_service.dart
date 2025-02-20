// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insight/body/homepage.dart';
import 'package:insight/intro/login.dart';
import 'package:insight/intro/profile_setup.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.sendEmailVerification();
      await FirebaseAuth.instance.signOut();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Verification Email Sent'),
            content: const Text('Please check your email for verification'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Field can not be empty';
      if (e.code == 'weak-password') {
        msg = 'The Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        msg = 'An Account already exist with the email.';
      }

      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _showToast('Email and password cannot be empty.');
      return;
    }
    _showLoadingDialog(context);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pop(context);

      if (!userCredential.user!.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: prefer_const_constructors
          SnackBar(
            content: const Text('Please verify your email to log in.'),
            backgroundColor: Colors.red,
          ),
        );

        await userCredential.user?.sendEmailVerification();

        await _auth.signOut();
      } else {
        await userCredential.user?.reload();
        final userId = userCredential.user!.uid;
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userDoc.exists) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ProfileSetup()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      _handleAuthException(e);
    } catch (e) {
      Navigator.pop(context);
      print(e.toString());
      _showToast('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    if (email.isEmpty) {
      _showToast('Please enter your email address.');
      return;
    }

    _showLoadingDialog(context);

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Navigator.pop(context);

      _showToast('Password reset Email Sent. Check Inbox');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      _handleAuthException(e);
    } catch (e) {
      Navigator.pop(context);
      print(e.toString());
      _showToast('An unexpected error occurred. Please try again.');
    }
  }

  // bool isSigningOut = false;
  // StreamSubscription<QuerySnapshot>? listener;

  Future<void> signout(context) async {
    try {
      print('Attempting to sign out...');
      await _auth.signOut();

      print('Sign out successful.');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _handleAuthException(FirebaseAuthException e) {
    String msg;

    switch (e.code) {
      case 'user-not-found':
        msg = 'No user found for this email.';
        break;
      case 'invalid-credential':
        msg = 'invalid-credential';
        break;
      case 'invalid-email':
        msg = 'The email address is invalid.';
        break;
      default:
        msg = 'An error occurred. Please try again.';
    }

    _showToast(msg);
  }
}

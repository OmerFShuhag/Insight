// lib/body/databaseViewModel2.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Home/MyProjectClass.dart';
import 'Home/EditProjectPage.dart';


class MyProjectViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  List<MyProjectClass> _myProjects = [];
  List<MyProjectClass> get myProjects => _myProjects;

  Future<void> fetchUserCreatedProjects() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('projects')
          .where('UserId', isEqualTo: userId)
          .get();
      _myProjects = snapshot.docs
          .map((doc) => MyProjectClass.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching user created projects: $e');
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
      await fetchUserCreatedProjects();
    } catch (e) {
      print('Error deleting project: $e');
    }
  }
}
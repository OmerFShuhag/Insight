import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insight/body/Project_class.dart';

class ProjectViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Project> _projects = [];
  List<Project> get projects => _projects;

  Future<void> fetchAllProjects() async {
    try {
      print("Fetching projects...");
      QuerySnapshot snapshot = await _firestore.collection('projects').get();
      print("Projects fetched successfully");

      _projects = snapshot.docs
          .map((doc) =>
              Project.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();

      print("Projects loaded: ${_projects.length}");
      notifyListeners();
    } catch (e) {
      print('Error fetching all projects: $e');
    }
  }

  Future<void> fetchUserCreatedProjects(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('projects')
          .where('createdBy', isEqualTo: userId)
          .get();
      _projects = snapshot.docs
          .map((doc) =>
              Project.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching user created projects: $e');
    }
  }

  Future<void> fetchFavoriteProjects(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      List<dynamic> favoriteProjectIds = userDoc['favorites'] ?? [];
      if (favoriteProjectIds.isEmpty) return;

      QuerySnapshot snapshot = await _firestore
          .collection('projects')
          .where(FieldPath.documentId, whereIn: favoriteProjectIds)
          .get();
      _projects = snapshot.docs
          .map((doc) =>
              Project.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching favorite projects: $e');
    }
  }

  Future<void> addFavoriteProject(String userId, String projectId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favoriteProjects': FieldValue.arrayUnion([projectId]),
      });
      notifyListeners();
    } catch (e) {
      print('Error adding favorite project: $e');
    }
  }

  Future<void> removeFavoriteProject(String userId, String projectId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([projectId]),
      });
      notifyListeners();
    } catch (e) {
      print('Error removing favorite project: $e');
    }
  }

  Future<void> addProject(Project project, String userId) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('projects').add(project.toMap());
      await _firestore.collection('users').doc(userId).update({
        'projects': FieldValue.arrayUnion([docRef.id]),
      });
      //after adding projects to the project collection i need to save the project id to that user who created it so write the code for that
      await _firestore.collection('users').doc(userId).update({
        'projects': FieldValue.arrayUnion([docRef.id]),
      });

      fetchUserCreatedProjects(userId);
    } catch (e) {
      print('Error adding project: $e');
    }
  }

  Future<void> editProject(Project project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toMap());
      fetchUserCreatedProjects(project.id);
    } catch (e) {
      print('Error editing project: $e');
    }
  }

  // Dlt kormu project user thaki
  Future<void> deleteProject(String projectId, String userId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
      await _firestore.collection('users').doc(userId).update({
        'projects': FieldValue.arrayRemove([projectId]),
      });
      fetchUserCreatedProjects(userId);
    } catch (e) {
      print('Error deleting project: $e');
    }
  }
}

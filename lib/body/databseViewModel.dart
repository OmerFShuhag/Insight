import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insight/body/Project_class.dart';

class ProjectViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Store project data
  List<Project> _projects = [];
  List<Project> get projects => _projects;

  // Fetch all projects from the database
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

  // Fetch projects created by the user
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

  // Fetch favorite projects
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

  /// Mark a project as a favorite for the user
  Future<void> addFavoriteProject(String userId, String projectId) async {
    try {
      // Add projectId to the user's favorites array
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([projectId]),
      });
      notifyListeners();
    } catch (e) {
      print('Error adding favorite project: $e');
    }
  }

  /// Remove a project from the user's favorites
  Future<void> removeFavoriteProject(String userId, String projectId) async {
    try {
      // Remove projectId from the user's favorites array
      await _firestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([projectId]),
      });
      notifyListeners();
    } catch (e) {
      print('Error removing favorite project: $e');
    }
  }

  // Add a new project to the database
  Future<void> addProject(Project project, String userId) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('projects').add(project.toMap());
      // Update the user profile with the new project ID
      await _firestore.collection('users').doc(userId).update({
        'projects': FieldValue.arrayUnion([docRef.id]),
      });
      fetchUserCreatedProjects(userId);
    } catch (e) {
      print('Error adding project: $e');
    }
  }

  // Edit project information
  Future<void> editProject(Project project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toMap());
      fetchUserCreatedProjects(project.id); // Refresh the data after editing
    } catch (e) {
      print('Error editing project: $e');
    }
  }

  // Delete a user's project
  Future<void> deleteProject(String projectId, String userId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
      // Remove the project ID from the user's list of projects
      await _firestore.collection('users').doc(userId).update({
        'projects': FieldValue.arrayRemove([projectId]),
      });
      fetchUserCreatedProjects(userId);
    } catch (e) {
      print('Error deleting project: $e');
    }
  }
}

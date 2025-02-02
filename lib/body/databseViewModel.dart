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
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_Projects')
          .get();

      List<String> favoriteProjectsId =
          snapshot.docs.map((doc) => doc.id).toList();

      if (favoriteProjectsId.isNotEmpty) {
        QuerySnapshot projectsSnapshot = await _firestore
            .collection('projects')
            .where(FieldPath.documentId, whereIn: favoriteProjectsId)
            .get();

        _projects = projectsSnapshot.docs
            .map((doc) =>
                Project.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
        notifyListeners();
        return;
      }
    } catch (e) {
      print('Error fetching favorite projects: $e');
    }
  }

  Future<void> addFavoriteProject(
      String userId, String projectId, BuildContext context) async {
    try {
      DocumentSnapshot favDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_Projects')
          .doc(projectId)
          .get();

      if (favDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project is already in favorites!')),
        );
        return;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_Projects')
          .doc(projectId)
          .set({'addedAt': Timestamp.now()});
    } catch (e) {
      print('Error adding favorite project: $e');
    }
  }

  Future<bool> isFavoriteProject(String userId, String projectId) async {
    try {
      DocumentSnapshot favoriteDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteProjects')
          .doc(projectId)
          .get();

      return favoriteDoc.exists;
    } catch (e) {
      print('Error checking favorite project: \$e');
      return false;
    }
  }

  Future<void> removeFavoriteProject(
      String userId, String projectId, BuildContext context) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_Projects')
          .doc(projectId)
          .delete();
    } catch (e) {
      print('Error removing favorite project: $e');
    }
  }

  Future<void> addProject(
      Project project, String userId, BuildContext context) async {
    // Check if the project name already exists
    QuerySnapshot existingProjects = await _firestore
        .collection('projects')
        .where('projectName', isEqualTo: project.projectName)
        .get();

    if (existingProjects.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project already exists!')),
      );
      return;
    }
    try {
      await _firestore.collection('projects').add(project.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project added successfully!')),
      );

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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insight/body/Project_class.dart';

class ProjectViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  List<Project> _projects = [];
  List<Project> get projects => _projects;

  List<Project> _favoriteProjects = [];
  List<Project> get favoriteProjects => _favoriteProjects;

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
          .where('UserId', isEqualTo: userId)
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

  Future<void> fetchFavoriteProjects() async {
    try {
      print("Favorite Fetching projects...");
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_Projects')
          .get();

      print("Favorite Projects fetched successfully");
      List<String> favoriteProjectsId =
          snapshot.docs.map((doc) => doc.id).toList();

      _favoriteProjects.clear();

      if (favoriteProjectsId.isNotEmpty) {
        QuerySnapshot projectsSnapshot = await _firestore
            .collection('projects')
            .where(FieldPath.documentId, whereIn: favoriteProjectsId)
            .get();

        _favoriteProjects = projectsSnapshot.docs
            .map((doc) =>
                Project.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList();
      }

      print("Favorite Projects loaded: ${_favoriteProjects.length}");
      notifyListeners();
    } catch (e) {
      print('Error fetching favorite projects: $e');
    }
  }

  Future<void> addFavoriteProject(
      String projectId, BuildContext context) async {
    try {
      DocumentSnapshot favDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_Projects')
          .doc(projectId)
          .get();

      if (favDoc.exists) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project is already in favorites!')),
          );
        }
        return;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_Projects')
          .doc(projectId)
          .set({'addedAt': Timestamp.now()});

      await fetchFavoriteProjects();
    } catch (e) {
      print('Error adding favorite project: $e');
    }
  }

  Future<bool> isFavoriteProject(String projectId) async {
    try {
      DocumentSnapshot favoriteDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_Projects')
          .doc(projectId)
          .get();

      return favoriteDoc.exists;
    } catch (e) {
      print('Error checking favorite project: \$e');
      return false;
    }
  }

  Future<void> removeFavoriteProject(
      String projectId, BuildContext context) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_Projects')
          .doc(projectId)
          .delete();

      await fetchFavoriteProjects();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      }
    } catch (e) {
      print('Error removing favorite project: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove favorite')),
        );
      }
    }
  }

  Future<void> addProject(
      Project project, String userId, BuildContext context) async {
    QuerySnapshot existingProjects = await _firestore
        .collection('projects')
        .where('projectName', isEqualTo: project.projectName)
        .get();

    if (existingProjects.docs.isNotEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project already exists!')),
        );
      }
      return;
    }
    try {
      await _firestore.collection('projects').add(project.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project added successfully!')),
      );

      fetchUserCreatedProjects(userId);
    } catch (e) {
      print('Error adding project: $e');
    }
  }
}

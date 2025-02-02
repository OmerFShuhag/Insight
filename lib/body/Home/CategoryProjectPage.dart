import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insight/body/Project_class.dart';
import 'package:insight/body/Project_list.dart';

class CategoryProjectsPage extends StatelessWidget {
  final String category;

  const CategoryProjectsPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects for $category'),
        backgroundColor: const Color(0xFF0ABAB5),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .where('category', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No projects found'));
          }

          final projects = snapshot.data!.docs.map((doc) {
            return Project.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          return ProjectListView(projects: projects);
        },
      ),
    );
  }
}
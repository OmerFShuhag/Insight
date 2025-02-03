import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insight/body/Project_class.dart';
import 'package:insight/body/databseViewModel.dart';
import 'package:provider/provider.dart';
import 'package:insight/body/Project_list.dart';
import 'package:insight/body/Home/Project_Details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProjects extends StatefulWidget {
  @override
  _MyProjectsState createState() => _MyProjectsState();
}

class _MyProjectsState extends State<MyProjects> {
  @override
  void initState() {
    super.initState();
    // Fetch user-created projects when the widget is initialized
    Future.microtask(() {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      // Using the provider to fetch the projects
      Provider.of<ProjectViewModel>(context, listen: false)
          .fetchUserCreatedProjects(userId);  // Pass userId here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
      ),
      body: Consumer<ProjectViewModel>(
        builder: (context, projectViewModel, child) {
          final projects = projectViewModel.projects;

          if (projects.isEmpty) {
            return Center(child: Text('No projects found.'));
          }

          return ProjectListView(projects: projects);
        },
      ),
    );
  }
}

class ProjectListView extends StatelessWidget {
  final List<Project> projects;

  const ProjectListView({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCard(project: project);
      },
    );
  }
}

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({required this.project});

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isExpanded = false;

  void _deleteProject(BuildContext context) async {
    // Show a confirmation dialog before deleting the project
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This will permanently delete the project.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the deletion
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // If the user confirms, delete the project
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await Provider.of<ProjectViewModel>(context, listen: false)
          .deleteProject(widget.project.id, userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      color: Colors.blue[50],
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Column(
          children: [
            ListTile(
              title: Text(widget.project.projectName),
              subtitle: Text(widget.project.category),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteProject(context),
              ),
            ),
            if (_isExpanded) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.project.description),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: widget.project.tags
                      .map((tag) => Chip(label: Text(tag)))
                      .toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProjectDetailsPage(project: widget.project),
                    ),
                  );
                },
                child: Text('View Full Project Info'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

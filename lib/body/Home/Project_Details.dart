import 'package:flutter/material.dart';
import 'package:insight/body/Project_class.dart'; // Import your Project class

class ProjectDetailsPage extends StatelessWidget {
  final Project project;

  const ProjectDetailsPage({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.projectName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project Name: ${project.projectName}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Category: ${project.category}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Supervisor: ${project.supervisorName}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('GitHub Link: ${project.githubLink}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Doc Link: ${project.DocLink}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Description:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(project.description, style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Text('Team Members:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...project.teamMembers.map((member) {
              return Text('Name: ${member['name']}, ID: ${member['id']}');
            }).toList(),
            SizedBox(height: 8),
            Text('Tags:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              children:
                  project.tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

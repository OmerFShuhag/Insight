import 'package:flutter/material.dart';
import 'package:insight/body/Project_class.dart';
import 'package:insight/body/Home/Project_Details.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      color: Colors.blue[50], // Change the card color here
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
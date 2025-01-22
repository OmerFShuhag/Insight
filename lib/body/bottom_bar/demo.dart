import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ProjectCard(
            projectName: 'Project Alpha',
            category: 'Category: Technology',
            description:
                'This is a description of Project Alpha. It focuses on cutting-edge technology to solve real-world problems.',
          ),
          ProjectCard(
            projectName: 'Project Beta',
            category: 'Category: Education',
            description:
                'Project Beta is designed to enhance learning through innovative educational tools.',
          ),
          ProjectCard(
            projectName: 'Project Gamma',
            category: 'Category: Healthcare',
            description:
                'This project aims to improve healthcare delivery using modern solutions.',
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final String projectName;
  final String category;
  final String description;

  const ProjectCard({
    Key? key,
    required this.projectName,
    required this.category,
    required this.description,
  }) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.projectName,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.category,
              style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isExpanded ? 'Hide Details' : 'View Details',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
            if (_isExpanded) ...[
              SizedBox(height: 8.0),
              Text(
                widget.description,
                style: TextStyle(fontSize: 14.0, color: Colors.black87),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

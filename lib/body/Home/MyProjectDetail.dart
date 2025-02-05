// lib/body/MyProjectDetail.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyProjectClass.dart';
import 'EditProjectPage.dart';
import 'myHomePage.dart';
import 'package:insight/body/databaseViewModel2.dart';

class MyProjectDetail extends StatefulWidget {
  final MyProjectClass project;

  const MyProjectDetail({Key? key, required this.project}) : super(key: key);

  @override
  _MyProjectDetailState createState() => _MyProjectDetailState();
}

class _MyProjectDetailState extends State<MyProjectDetail> {
  late MyProjectClass _project;
  late TextEditingController _descriptionController;
  late TextEditingController _githubLinkController;
  late TextEditingController _docLinkController;
  late TextEditingController _teamMembersController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
    _descriptionController = TextEditingController(text: _project.description);
    _githubLinkController = TextEditingController(text: _project.githubLink);
    _docLinkController = TextEditingController(text: _project.DocLink);
    _teamMembersController = TextEditingController(text: _project.teamMembers.join(', '));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _githubLinkController.dispose();
    _docLinkController.dispose();
    _teamMembersController.dispose();
    super.dispose();
  }

  void _updateProjectDetails(MyProjectClass updatedProject) {
    setState(() {
      _project = updatedProject;
      _descriptionController.text = updatedProject.description;
      _githubLinkController.text = updatedProject.githubLink;
      _docLinkController.text = updatedProject.DocLink;
      _teamMembersController.text = updatedProject.teamMembers.join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_project.projectName),
        backgroundColor: const Color(0xFF0ABAB5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextField(
              controller: _githubLinkController,
              decoration: InputDecoration(labelText: 'GitHub Link'),
            ),
            TextField(
              controller: _docLinkController,
              decoration: InputDecoration(labelText: 'DocLink'),
            ),
            TextField(
              controller: _teamMembersController,
              decoration: InputDecoration(labelText: 'Team Members (comma separated)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedProject = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProjectPage(project: _project),
                  ),
                );
                if (updatedProject != null) {
                  _updateProjectDetails(updatedProject);
                }
              },
              child: Text('Edit Project'),
            )
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (_isExpanded) ...[
                  FloatingActionButton(
                    onPressed: () async {
                      final updatedProject = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProjectPage(project: _project),
                        ),
                      );
                      if (updatedProject != null) {
                        _updateProjectDetails(updatedProject);
                      }
                    },
                    backgroundColor: const Color(0xFF0ABAB5),
                    foregroundColor: Colors.white,
                    mini: true,
                    child: Icon(Icons.edit),
                  ),
                  SizedBox(height: 8),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(), // Navigate to MyHomePage
                        ),
                      );
                    },
                    mini: true,
                    backgroundColor: const Color(0xFFBEFFFD),
                    child: const ImageIcon(AssetImage('assets/icons/chatbot.png')),
                  ),
                  const SizedBox(height: 8),
                ],
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  backgroundColor: const Color(0xFFBEFFFD),
                  foregroundColor: Colors.white,
                  child: _isExpanded ? Icon(Icons.close) : Image.asset('assets/icons/spread.gif', height: 40, width: 40, fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
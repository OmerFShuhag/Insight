import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insight/body/Home/AllProjects.dart';
import 'package:insight/body/databseViewModel.dart';
import 'package:insight/body/Project_class.dart' as projectClass;
import 'package:insight/body/homepage.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _supervisorNameController =
      TextEditingController();
  final TextEditingController _githubLinkController = TextEditingController();

  String _selectedCategory = 'E-commerce';
  final List<String> _categories = [
    'E-commerce',
    'Education',
    'Lifestyle',
    'Entertainment',
    'Ticket-booking',
    'Game',
    'Health & Fitness',
    'Productivity',
    'Travel',
    'Medical',
    'News',
    'Social Media',
    'Self Care',
    'Other'
  ];

  List<Map<String, String>> _teamMembers = [];
  final int _maxTeamMembers = 3;
  List<String> _selectedTags = [];
  final List<String> _availableTags = [
    'Android',
    'Web',
    'C++',
    'Flutter',
    'CSS',
    'Node',
    'React'
  ];

  void _addTeamMember(String name, String id) {
    if (_teamMembers.length < _maxTeamMembers) {
      setState(() {
        _teamMembers.add({'name': name, 'id': id});
      });
    }
  }

  void _removeTeamMember(int index) {
    setState(() {
      _teamMembers.removeAt(index);
    });
  }

  Future<void> _saveProject() async {
    if (_formKey.currentState!.validate()) {
      final String projectId =
          ''; // Initialize with an empty ID for a new project
      final project = projectClass.Project(
        id: projectId,
        projectName: _projectNameController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        teamMembers: _teamMembers,
        supervisorName: _supervisorNameController.text,
        githubLink: _githubLinkController.text,
        tags: _selectedTags,
      );
      // Project(
      //   id: projectId,
      //   projectName: _projectNameController.text,
      //   description: _descriptionController.text,
      //   category: _selectedCategory,
      //   teamMembers: _teamMembers,
      //   supervisorName: _supervisorNameController.text,
      //   githubLink: _githubLinkController.text,
      //   tags: _selectedTags,
      // );

      final String userId = FirebaseAuth.instance.currentUser!.uid;

      try {
        await ProjectViewModel().addProject(project, userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project added successfully!')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _teamMembers.clear();
          _selectedTags.clear();
          _selectedCategory = _categories.first;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding project: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Project'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _projectNameController,
                decoration: InputDecoration(labelText: 'Project Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter project name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter description' : null,
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value as String;
                  });
                },
              ),
              Text('Team Members (Max $_maxTeamMembers):'),
              ..._teamMembers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> member = entry.value;
                return ListTile(
                  title: Text('Name: ${member['name']}'),
                  subtitle: Text('ID: ${member['id']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeTeamMember(index),
                  ),
                );
              }).toList(),
              if (_teamMembers.length < _maxTeamMembers)
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final nameController = TextEditingController();
                        final idController = TextEditingController();
                        return AlertDialog(
                          title: Text('Add Team Member'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(labelText: 'Name'),
                              ),
                              TextField(
                                controller: idController,
                                decoration: InputDecoration(labelText: 'ID'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _addTeamMember(
                                    nameController.text, idController.text);
                                Navigator.pop(context);
                              },
                              child: Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Add Team Member'),
                ),
              TextFormField(
                controller: _supervisorNameController,
                decoration: InputDecoration(labelText: 'Supervisor Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter supervisor name' : null,
              ),
              TextFormField(
                controller: _githubLinkController,
                decoration: InputDecoration(labelText: 'GitHub Link'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter GitHub link' : null,
              ),
              Text('Tags:'),
              Wrap(
                spacing: 8.0,
                children: _availableTags.map((tag) {
                  return FilterChip(
                    label: Text(tag),
                    selected: _selectedTags.contains(tag),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProject,
                  child: Text('Save Project'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

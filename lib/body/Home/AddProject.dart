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
  final TextEditingController _docLinkController = TextEditingController();

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
      final String projectId = '';
      final project = projectClass.Project(
        id: projectId,
        projectName: _projectNameController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        teamMembers: _teamMembers,
        supervisorName: _supervisorNameController.text,
        githubLink: _githubLinkController.text,
        DocLink: '',
        tags: _selectedTags,
      );

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
        title: const Text(
          'Add Project',
          style: TextStyle(
            fontSize: 24,
            color: const Color.fromARGB(255, 243, 243, 243),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 10, 186, 180),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _projectNameController,
                label: 'Project Name',
                validatorMessage: 'Please enter project name',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
                validatorMessage: 'Please enter description',
              ),
              const SizedBox(height: 10),
              _buildDropdownField(),
              const SizedBox(height: 16.0),
              _buildTeamMembersSection(),
              _buildTextField(
                controller: _supervisorNameController,
                label: 'Supervisor Name',
                validatorMessage: 'Please enter supervisor name',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _githubLinkController,
                label: 'GitHub Link',
                validatorMessage: 'Please enter GitHub link',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _docLinkController,
                label: 'Documentation Link',
                validatorMessage: 'Please enter documentation link',
              ),
              const SizedBox(height: 10),
              _buildTagsSection(),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProject,
                  child: const Text('Save Project'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? validatorMessage,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      maxLines: maxLines,
      validator: (value) =>
          value != null && value.isEmpty ? validatorMessage : null,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField(
      value: _selectedCategory,
      decoration: const InputDecoration(labelText: 'Category'),
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
    );
  }

  Widget _buildTeamMembersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Team Members (Max $_maxTeamMembers):',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        if (_teamMembers.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _teamMembers.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> member = entry.value;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  title: Text(
                    'Name: ${member['name']}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('ID: ${member['id']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeTeamMember(index),
                  ),
                );
              }).toList(),
            ),
          )
        else
          const Text(
            'No team members added yet.',
            style: TextStyle(color: Colors.grey),
          ),
        if (_teamMembers.length < _maxTeamMembers)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton.icon(
              onPressed: _showAddTeamMemberDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Team Member     '),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 22, 190, 154),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
      ],
    );
  }

  void _showAddTeamMemberDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add Team Member',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: nameController,
                  label: 'Name',
                  validatorMessage: 'Name is required',
                ),
                const SizedBox(height: 8.0),
                _buildTextField(
                  controller: idController,
                  label: 'ID',
                  validatorMessage: 'ID is required',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    idController.text.isNotEmpty) {
                  _addTeamMember(nameController.text, idController.text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 22, 190, 154),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags:',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
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
                selectedColor: Colors.blueAccent.withOpacity(0.2),
                checkmarkColor: Colors.blueAccent,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: _selectedTags.contains(tag)
                      ? Colors.blueAccent
                      : Colors.black87,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: _selectedTags.contains(tag)
                        ? Colors.blueAccent
                        : Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

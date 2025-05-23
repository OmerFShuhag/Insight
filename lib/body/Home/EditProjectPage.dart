import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insight/body/Home/MyProjects.dart';
import 'package:insight/body/databaseViewModel2.dart';
import 'package:insight/validators.dart';
import 'MyProjectClass.dart';

class EditProjectPage extends StatefulWidget {
  final MyProjectClass project;

  const EditProjectPage({super.key, required this.project});

  @override
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _supervisorNameController =
      TextEditingController();
  final TextEditingController _githubLinkController = TextEditingController();
  final TextEditingController _docLinkController = TextEditingController();

  String _selectedCategory = 'E-Commerce';
  final List<String> _categories = [
    'E-Commerce',
    'Education/E-learning',
    'Lifestyle',
    'Entertainment',
    'Ticket-Booking',
    'Game',
    'Health & Fitness',
    'Productivity',
    'Travel',
    'Medical',
    'News',
    'Social Media',
    'Self-Care',
    'Others'
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
    'React',
    'Python',
    'Java',
    'JavaScript',
  ];

  bool _isFormValid = false;
  bool _teamMembersTouched = false;

  @override
  void initState() {
    super.initState();
    _projectNameController.text = widget.project.projectName;
    _descriptionController.text = widget.project.description;
    _selectedCategory = widget.project.category;
    _teamMembers = widget.project.teamMembers;
    _supervisorNameController.text = widget.project.supervisorName;
    _githubLinkController.text = widget.project.githubLink;
    _docLinkController.text = widget.project.DocLink;
    _selectedTags = widget.project.tags;
  }

  void _addTeamMember(String name, String id) {
    if (_teamMembers.length < _maxTeamMembers) {
      setState(() {
        _teamMembers.add({'name': name, 'id': id});
        _teamMembersTouched = true;
      });
      _checkFormValidity();
    }
  }

  void _removeTeamMember(int index) {
    setState(() {
      _teamMembers.removeAt(index);
      _teamMembersTouched = true;
    });
    _checkFormValidity();
  }

  void _checkFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;

    final teamValid = _teamMembers.isNotEmpty;
    setState(() {
      _isFormValid = isValid && teamValid;
    });
  }

  Future<void> _saveProject() async {
    if (_formKey.currentState!.validate() && _teamMembers.isNotEmpty) {
      final Uproject = MyProjectClass(
        UserId: FirebaseAuth.instance.currentUser!.uid,
        id: widget.project.id,
        projectName: _projectNameController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        teamMembers: _teamMembers,
        supervisorName: _supervisorNameController.text,
        githubLink: _githubLinkController.text,
        DocLink: _docLinkController.text,
        tags: _selectedTags,
      );

      try {
        await FirebaseFirestore.instance
            .collection('projects')
            .doc(widget.project.id)
            .update(Uproject.toMap());

        await MyProjectViewModel().fetchUserCreatedProjects();

        _formKey.currentState!.reset();
        setState(() {
          _teamMembers.clear();
          _selectedTags.clear();
          _selectedCategory = _categories.first;
          _teamMembersTouched = false;
          _isFormValid = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project updated successfully!')),
        );

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyProjects()));
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
          'Edit Project',
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 243, 243, 243),
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
                hint: '',
                controller: _projectNameController,
                label: 'Project Name',
                validator: (value) =>
                    Validators.validateField(value, 'Project Name'),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                hint: '',
                controller: _descriptionController,
                label: 'Description',
                maxLines: 5,
                validator: (value) =>
                    Validators.validateField(value, 'Description'),
              ),
              const SizedBox(height: 10),
              _buildDropdownField(),
              const SizedBox(height: 16.0),
              _buildTeamMembersSection(),
              const SizedBox(height: 20.0),
              _buildTextField(
                hint: '',
                controller: _supervisorNameController,
                label: 'Supervisor Name',
                validator: (value) =>
                    Validators.validateField(value, 'Supervisor Name'),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                hint: 'https://github.com/user/repo',
                controller: _githubLinkController,
                label: 'GitHub Link',
                validator: (value) =>
                    Validators.validateField(value, 'GitHub Link'),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                hint: '',
                controller: _docLinkController,
                label: 'Documentation Link',
                validator: (value) =>
                    Validators.validateField(value, 'Document Link'),
              ),
              const SizedBox(height: 10),
              _buildTagsSection(),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _isFormValid ? _saveProject : null,
                  style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 10, 186, 180),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    'Update Project',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    required String label,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
        filled: true,
        fillColor: Colors.teal.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.teal, width: 2)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      maxLines: maxLines,
      validator: validator,
      onChanged: (_) => _checkFormValidity(),
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
        if (_teamMembersTouched && _teamMembers.isEmpty)
          const Text(
            'Please add at least one team member.',
            style: TextStyle(color: Colors.red),
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
                  hint: '',
                  controller: nameController,
                  label: 'Name',
                  validator: (value) =>
                      Validators.validateField(value, 'Team Member Name'),
                ),
                const SizedBox(height: 8.0),
                _buildTextField(
                  hint: '',
                  controller: idController,
                  label: 'ID',
                  validator: (value) =>
                      Validators.validateField(value, 'Team Member ID'),
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
                backgroundColor: const Color.fromARGB(255, 22, 190, 154),
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
                offset: const Offset(0, 2),
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
                  _checkFormValidity();
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

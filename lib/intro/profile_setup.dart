// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insight/validators.dart';
import 'package:insight/globals.dart';
import 'package:insight/user_class.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  String _selectedSemester = 'Spring';
  int _selectedYear = 2010;
  int _selectedBatch = 40;
  User_class? _user;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        _user = User_class.fromMap(userDoc.data()!);
        _nameController.text = _user!.name;
        _idController.text = _user!.id;
        _selectedSemester = _user!.semester;
        _selectedYear = _user!.year;
        _selectedBatch = _user!.batch;
      });
    } else {
      _user = User_class(
        id: '',
        name: '',
        semester: 'Spring',
        year: 2010,
        batch: 40,
      );
    }
  }

  Future<void> _saveProfileData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    _user = User_class(
      id: _idController.text,
      name: _nameController.text,
      semester: _selectedSemester,
      year: _selectedYear,
      batch: _selectedBatch,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(_user!.toMap());

    Navigator.pushReplacementNamed(context, '/homepage');
  }

  Widget _buildNameField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _nameController,
      decoration: const InputDecoration(
          labelText: 'Name', border: OutlineInputBorder()),
      validator: (value) => Validators.validateName(value ?? ''),
    );
  }

  Widget _buildIDField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _idController,
      decoration:
          const InputDecoration(labelText: 'ID', border: OutlineInputBorder()),
      validator: (value) => Validators.validateID(value ?? ''),
    );
  }

  Widget _buildBatchDropdown() {
    return DropdownButtonFormField(
      value: _selectedBatch,
      decoration: const InputDecoration(
          labelText: 'Batch', border: OutlineInputBorder()),
      items: List.generate(24, (index) => 40 + index)
          .map((batch) => DropdownMenuItem(value: batch, child: Text('$batch')))
          .toList(),
      onChanged: (value) => setState(() => _selectedBatch = value as int),
    );
  }

  Widget _buildSemesterYearRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedSemester,
            decoration: const InputDecoration(labelText: 'Semester'),
            items: ['Spring', 'Summer', 'Fall']
                .map((semester) =>
                    DropdownMenuItem(value: semester, child: Text(semester)))
                .toList(),
            onChanged: (value) => setState(() => _selectedSemester = value!),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedYear,
            decoration: const InputDecoration(labelText: 'Year'),
            items: List.generate(21, (index) => 2010 + index)
                .map((year) =>
                    DropdownMenuItem(value: year, child: Text(year.toString())))
                .toList(),
            onChanged: (value) => setState(() => _selectedYear = value!),
          ),
        ),
        IconButton(
          icon: Icon(Icons.help_outline, color: Colors.grey.withOpacity(0.6)),
          onPressed: _showSemesterInfoDialog,
        ),
      ],
    );
  }

  void _showSemesterInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Semester Information'),
        content: const Text(
            'Please select the semester and year of your admission.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          await _saveProfileData();
        }
      },
      child: Text(isProfileInfoSet ? 'Update Profile' : 'Save Profile'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildNameField(),
              const SizedBox(height: 10),
              _buildIDField(),
              const SizedBox(height: 10),
              _buildBatchDropdown(),
              const SizedBox(height: 10),
              _buildSemesterYearRow(),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}

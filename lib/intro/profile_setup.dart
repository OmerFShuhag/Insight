// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insight/validators.dart';
import 'package:numberpicker/numberpicker.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile Setup'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 10, 186, 180),
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
              _buildBatch(),
              const SizedBox(height: 10),
              _buildSemesterYearRow(),
              const SizedBox(height: 50),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _nameController,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: 'Name',
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
          prefixIcon: const Icon(Icons.person, color: Colors.teal),
          filled: true,
          fillColor: Colors.teal.shade50,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.teal, width: 2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
        validator: (value) => Validators.validateName(value ?? ''),
      ),
    );
  }

  Widget _buildIDField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: _idController,
        decoration: InputDecoration(
            labelText: 'Student ID',
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            prefixIcon: const Icon(Icons.badge, color: Colors.teal),
            filled: true,
            fillColor: Colors.teal.shade50,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.teal, width: 2)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.teal, width: 2),
            )),
        validator: (value) => Validators.validateID(value ?? ''),
      ),
    );
  }

  Widget _buildBatch() {
    return Column(
      children: [
        Text(
          'Batch',
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            //backgroundColor: Colors.teal.shade50,
          ),
        ),
        NumberPicker(
          value: _selectedBatch,
          minValue: 40,
          maxValue: 63,
          itemHeight: 40,
          axis: Axis.horizontal,
          selectedTextStyle: TextStyle(
              color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold),
          textStyle: TextStyle(color: Colors.grey),
          onChanged: (value) => setState(() => _selectedBatch = value),
        ),
      ],
    );
  }

  Widget _buildSemesterYearRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedSemester,
            decoration: InputDecoration(
              labelText: 'Semester',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              prefixIcon: const Icon(Icons.school, color: Colors.teal),
              filled: true,
              fillColor: Colors.teal.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.teal, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.teal, width: 2),
              ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: TextStyle(
              color: Colors.teal.shade800,
              fontSize: 16,
            ),
            selectedItemBuilder: (context) => ['Spring', 'Summer', 'Fall']
                .map((semester) => Center(
                      child: Text(
                        semester,
                        style: TextStyle(
                            color: Colors.teal.shade800, fontSize: 16),
                      ),
                    ))
                .toList(),
            items: ['Spring', 'Summer', 'Fall']
                .map((semester) => DropdownMenuItem(
                      value: semester,
                      child: Text(semester,
                          style: TextStyle(
                            color: Colors.teal.shade800,
                            fontSize: 16,
                          )),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _selectedSemester = value!),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<int>(
            value: _selectedYear,
            decoration: InputDecoration(
              labelText: 'Year',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              prefixIcon: const Icon(Icons.calendar_today, color: Colors.teal),
              filled: true,
              fillColor: Colors.teal.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.teal, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.teal, width: 2),
              ),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: TextStyle(
              color: Colors.teal.shade800,
              fontSize: 16,
            ),
            selectedItemBuilder: (context) =>
                List.generate(21, (index) => 2010 + index)
                    .map((year) => Center(
                          child: Text(year.toString(),
                              style: TextStyle(
                                  color: Colors.teal.shade800, fontSize: 16)),
                        ))
                    .toList(),
            items: List.generate(21, (index) => 2010 + index)
                .map((year) => DropdownMenuItem(
                      value: year,
                      child: Text(year.toString(),
                          style: TextStyle(
                            color: Colors.teal.shade800,
                            fontSize: 16,
                          )),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _selectedYear = value!),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.help_outline,
            color: Colors.teal.withOpacity(0.8),
            size: 28,
          ),
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
      style: TextButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 10, 186, 180),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Text(
        isProfileInfoSet ? 'Update Profile' : 'Save Profile',
        //selectionColor: Color.fromARGB(255, 10, 186, 180);,
        style: const TextStyle(color: Colors.white, fontSize: 17),
      ),
    );
  }
}

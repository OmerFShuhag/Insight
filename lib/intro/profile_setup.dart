import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insight/body/bottom_bar/profile.dart';
import 'package:insight/body/homepage.dart';
import 'package:insight/intro/login.dart';
import 'package:insight/validators.dart';
import 'package:insight/globals.dart';
import 'package:insight/user_class.dart';

class ProfileSetup extends StatefulWidget {
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  String _selectedSemester = 'Spring';
  int _selectedYear = 2010;
  User_class? _user;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userId == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      return;
    }

    if (userDoc.exists) {
      setState(() {
        _user = User_class.fromMap(userDoc.data()!);
        _nameController.text = _user!.name;
        _idController.text = _user!.id;
        _selectedSemester = _user!.semester;
        _selectedYear = _user!.year;
        isProfileInfoSet = true;
      });
    } else {
      _user = User_class(
        id: '',
        name: '',
        semester: 'Spring',
        year: 2010,
        createdProjects: [],
        favoriteProjects: [],
      );
      isProfileInfoSet = false;
    }
  }

  Future<void> _saveProfileData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    _user = User_class(
      id: _idController.text,
      name: _nameController.text,
      semester: _selectedSemester,
      year: _selectedYear,
      createdProjects: _user?.createdProjects ?? [],
      favoriteProjects: _user?.favoriteProjects ?? [],
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(_user!.toMap());

    isProfileInfoSet = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name', border: OutlineInputBorder()),
                validator: (value) {
                  return Validators.validateName(value ?? '');
                },
              ),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) {
                  return Validators.validateID(value ?? '');
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSemester,
                      decoration: InputDecoration(labelText: 'Semester'),
                      items: ['Spring', 'Summer', 'Fall']
                          .map((semester) => DropdownMenuItem(
                                value: semester,
                                child: Text(semester),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSemester = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedYear,
                      decoration: InputDecoration(labelText: 'Year'),
                      items: List.generate(
                        21,
                        (index) => 2010 + index,
                      )
                          .map((year) => DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value!;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.help_outline,
                        color: Colors.grey.withOpacity(0.6)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Semester Information'),
                          content: Text(
                              'Please select the semester and year of your admission.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _saveProfileData();
                    Navigator.pop(context);
                  }
                },
                child:
                    Text(isProfileInfoSet ? 'Update Profile' : 'Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

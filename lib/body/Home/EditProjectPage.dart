import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MyProjectClass.dart';

class EditProjectPage extends StatefulWidget {
  final MyProjectClass project;

  const EditProjectPage({Key? key, required this.project}) : super(key: key);

  @override
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _githubLinkController;
  late TextEditingController _docLinkController;
  late TextEditingController _teamMemberNameController;
  List<Map<String, String>> _teamMembers = [];

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.project.description);
    _githubLinkController = TextEditingController(text: widget.project.githubLink);
    _docLinkController = TextEditingController(text: widget.project.DocLink);
    _teamMemberNameController = TextEditingController();
    _teamMembers = List.from(widget.project.teamMembers);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _githubLinkController.dispose();
    _docLinkController.dispose();
    _teamMemberNameController.dispose();
    super.dispose();
  }

  void _addTeamMember() {
    if (_teamMemberNameController.text.isNotEmpty) {
      setState(() {
        _teamMembers.add({'name': _teamMemberNameController.text});
        _teamMemberNameController.clear();
      });
    }
  }

  void _removeTeamMember(int index) {
    setState(() {
      _teamMembers.removeAt(index);
    });
  }

  void _saveChanges() async {
    final updatedProject = MyProjectClass(
      UserId: widget.project.UserId,
      id: widget.project.id,
      projectName: widget.project.projectName,
      description: _descriptionController.text,
      category: widget.project.category,
      teamMembers: _teamMembers,
      supervisorName: widget.project.supervisorName,
      githubLink: _githubLinkController.text,
      DocLink: _docLinkController.text,
      tags: widget.project.tags,
    );

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.project.id)
        .update(updatedProject.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Project updated successfully!')),
    );

    Navigator.pop(context, updatedProject); // Pass the updated project back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Project')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _githubLinkController,
              decoration: InputDecoration(labelText: 'GitHub Link'),
            ),
            TextField(
              controller: _docLinkController,
              decoration: InputDecoration(labelText: 'Doc Link'),
            ),
            const SizedBox(height: 20),
            Text('Team Members:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _teamMembers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_teamMembers[index]['name']!),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeTeamMember(index),
                  ),
                );
              },
            ),
            TextField(
              controller: _teamMemberNameController,
              decoration: InputDecoration(
                labelText: 'Add Team Member',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTeamMember,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'MyProjectClass.dart';
//
// class EditProjectPage extends StatefulWidget {
//   final MyProjectClass project;
//
//   const EditProjectPage({Key? key, required this.project}) : super(key: key);
//
//   @override
//   _EditProjectPageState createState() => _EditProjectPageState();
// }
//
// class _EditProjectPageState extends State<EditProjectPage> {
//   late TextEditingController _descriptionController;
//   late TextEditingController _githubLinkController;
//   late TextEditingController _docLinkController;
//   late TextEditingController _teamMembersController;
//
//   @override
//   void initState() {
//     super.initState();
//     _descriptionController = TextEditingController(text: widget.project.description);
//     _githubLinkController = TextEditingController(text: widget.project.githubLink);
//     _docLinkController = TextEditingController(text: widget.project.DocLink);
//     _teamMembersController = TextEditingController(text: widget.project.teamMembers.map((e) => e['name']).join(', '));
//   }
//
//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     _githubLinkController.dispose();
//     _docLinkController.dispose();
//     _teamMembersController.dispose();
//     super.dispose();
//   }
//
//   void _saveChanges() async {
//     final updatedProject = MyProjectClass(
//       UserId: widget.project.UserId,
//       id: widget.project.id,
//       projectName: widget.project.projectName,
//       description: _descriptionController.text,
//       category: widget.project.category,
//       teamMembers: _teamMembersController.text.split(', ').map((e) => {'name': e}).toList(),
//       supervisorName: widget.project.supervisorName,
//       githubLink: _githubLinkController.text,
//       DocLink: _docLinkController.text,
//       tags: widget.project.tags,
//     );
//
//     await FirebaseFirestore.instance
//         .collection('projects')
//         .doc(widget.project.id)
//         .update(updatedProject.toMap());
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Project updated successfully!')),
//     );
//
//     Navigator.pop(context, updatedProject); // Pass the updated project back
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Edit Project')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//             ),
//             TextField(
//               controller: _githubLinkController,
//               decoration: InputDecoration(labelText: 'GitHub Link'),
//             ),
//             TextField(
//               controller: _docLinkController,
//               decoration: InputDecoration(labelText: 'Doc Link'),
//             ),
//             TextField(
//               controller: _teamMembersController,
//               decoration: InputDecoration(labelText: 'Team Members: '),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveChanges,
//               child: Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
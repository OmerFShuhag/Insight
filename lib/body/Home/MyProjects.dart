import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyProjectClass.dart';
import 'package:insight/body/databaseViewModel2.dart';
import 'MyProjectDetail.dart';

class MyProjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProjectViewModel()..fetchUserCreatedProjects(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Projects'),
        ),
        body: Consumer<MyProjectViewModel>(
          builder: (context, viewModel, child) {
            final projects = viewModel.myProjects;
            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ProjectCard(project: project);
              },
            );
          },
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final MyProjectClass project;

  const ProjectCard({required this.project});

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isExpanded = false;
  late Color _cardColor;

  @override
  void initState() {
    super.initState();
    _cardColor = _generateRandomColor();
  }

  Color _generateRandomColor() {
    final random = Random();
    List<Color> colors = [
      const Color(0xC2DD61F8),
      const Color(0xFFFF769D),
      const Color(0xFFA4C8F0),
      const Color(0xFFE5B1F2),
      const Color(0xFFFFAB87),
      const Color(0xFFB6E3A5),
      const Color(0xFFD3A4E3),
      const Color(0xFF95D9F0),
      const Color(0xFFF7D794),
      const Color(0xFFFFB4A2),
      const Color(0xFF8C88E8),
      const Color(0xFF857FFF),
      const Color(0xFF89D8A7),
      const Color(0xFFFFC1D3),
    ];
    return colors[random.nextInt(colors.length)];
  }

  void _deleteProject(BuildContext context) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This will permanently delete the project.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await Provider.of<MyProjectViewModel>(context, listen: false)
          .deleteProject(widget.project.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      color: _cardColor,
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.project.projectName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                widget.project.category,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF515959),
                    fontWeight: FontWeight.bold
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.white),
                onPressed: () => _deleteProject(context),
              ),
            ),
            if (_isExpanded)
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 17.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.project.description,
                        style: const TextStyle(
                            color: Color(0xFF353D3D),
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: widget.project.tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            backgroundColor: const Color(0xFFD9F6F5),
                            shape: const StadiumBorder(
                              side: BorderSide(color: Color(0xFFFFFFFF)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFFFFF),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyProjectDetail(project: widget.project),
                            ),
                          );
                        },
                        child: const Text(
                          'View Full Project Info',
                          style: TextStyle(
                            color: Color(0xFF113837),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'MyProjectClass.dart';
// import 'package:insight/body/databseViewModel.dart';
// import 'package:provider/provider.dart';
// import 'package:insight/body/Home/Project_Details.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'MyProjectDetail.dart';
// import 'package:insight/body/bottom_bar/dashboard.dart';
//
// class MyProjects extends StatelessWidget {
//   final List<MyProjectClass> projects;
//
//   const MyProjects({Key? key, required this.projects}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Projects'),
//       ),
//       body: ListView.builder(
//         itemCount: projects.length,
//         itemBuilder: (context, index) {
//           final project = projects[index];
//           return ProjectCard(project: project);
//         },
//       ),
//     );
//   }
// }
//
// class ProjectCard extends StatefulWidget {
//   final MyProjectClass project;
//
//   const ProjectCard({required this.project});
//
//   @override
//   _ProjectCardState createState() => _ProjectCardState();
// }
//
// class _ProjectCardState extends State<ProjectCard> {
//   bool _isExpanded = false;
//   late Color _cardColor;
//
//   @override
//   void initState() {
//     super.initState();
//     _cardColor = _generateRandomColor();
//   }
//
//   Color _generateRandomColor() {
//     final random = Random();
//     List<Color> colors = [
//       const Color(0xC2DD61F8),
//       const Color(0xFFFF769D),
//       const Color(0xFFA4C8F0),
//       const Color(0xFFE5B1F2),
//       const Color(0xFFFFAB87),
//       const Color(0xFFB6E3A5),
//       const Color(0xFFD3A4E3),
//       const Color(0xFF95D9F0),
//       const Color(0xFFF7D794),
//       const Color(0xFFFFB4A2),
//       const Color(0xFF8C88E8),
//       const Color(0xFF857FFF),
//       const Color(0xFF89D8A7),
//       const Color(0xFFFFC1D3),
//     ];
//     return colors[random.nextInt(colors.length)];
//   }
//
//   void _deleteProject(BuildContext context) async {
//     bool? confirmDelete = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Are you sure?'),
//           content: Text('This will permanently delete the project.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirmDelete == true) {
//       final userId = FirebaseAuth.instance.currentUser!.uid;
//       await Provider.of<ProjectViewModel>(context, listen: false)
//           .deleteProject(widget.project.id, userId);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Project deleted successfully!')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(10),
//       elevation: 4,
//       color: _cardColor,
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             _isExpanded = !_isExpanded;
//           });
//         },
//         child: Column(
//           children: [
//             ListTile(
//               title: Text(
//                 widget.project.projectName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 19,
//                   color: Colors.black,
//                 ),
//               ),
//               subtitle: Text(
//                 widget.project.category,
//                 style: const TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF515959),
//                     fontWeight: FontWeight.bold
//                 ),
//               ),
//               trailing: IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.white),
//                 onPressed: () => _deleteProject(context),
//               ),
//             ),
//             if (_isExpanded)
//               Container(
//                 margin: const EdgeInsets.only(top: 10.0, bottom: 17.0),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         widget.project.description,
//                         style: const TextStyle(
//                             color: Color(0xFF353D3D),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Wrap(
//                         spacing: 8.0,
//                         runSpacing: 4.0,
//                         children: widget.project.tags.map((tag) {
//                           return Chip(
//                             label: Text(tag),
//                             backgroundColor: const Color(0xFFD9F6F5),
//                             shape: const StadiumBorder(
//                               side: BorderSide(color: Color(0xFFFFFFFF)),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFFFFFFF),
//                         ),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   MyProjectDetail(project: widget.project),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           'View Full Project Info',
//                           style: TextStyle(
//                             color: Color(0xFF113837),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
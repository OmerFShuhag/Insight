import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insight/body/Project_class.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;

  ProjectDetailsPage({required this.project});

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool _showGitHubLink = false;
  bool _showDocLink = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEFCFC), // Set background color
      appBar: AppBar(
        title: Text(
          widget.project.projectName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0ABAB5), // AppBar color
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Overview Card
            _buildOverviewCard(context),
            SizedBox(height: 20),

            // Links Section
            _buildLinkSection(
              context,
              'GitHub Repository',
              Icons.code,
              widget.project.githubLink,
              _showGitHubLink,
              () {
                setState(() {
                  _showGitHubLink = !_showGitHubLink;
                });
              },
            ),
            SizedBox(height: 16),
            _buildLinkSection(
              context,
              'See Doc File',
              Icons.description,
              widget.project.DocLink,
              _showDocLink,
              () {
                setState(() {
                  _showDocLink = !_showDocLink;
                });
              },
            ),
            SizedBox(height: 20),

            // Description Section
            _buildSectionTitle('Description'),
            _buildSectionContent(widget.project.description),
            SizedBox(height: 20),

            // Team Members Section
            _buildSectionTitle('Team Members'),
            ...widget.project.teamMembers.map((member) {
              return _buildTeamMemberCard(member['name']!, member['id']!);
            }).toList(),
            SizedBox(height: 20),

            // Tags Section
            _buildSectionTitle('Tags'),
            Wrap(
              spacing: 8,
              children: widget.project.tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor:
                            const Color(0xFF0ABAB5).withOpacity(0.2),
                        labelStyle: TextStyle(color: const Color(0xFF0ABAB5)),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Project Overview Card
  Widget _buildOverviewCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.category, 'Category', widget.project.category),
            SizedBox(height: 12),
            _buildInfoRow(Icons.supervisor_account, 'Supervisor',
                widget.project.supervisorName),
          ],
        ),
      ),
    );
  }

  // Widget for Info Row with Icon
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0ABAB5)),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Widget for Link Section
  Widget _buildLinkSection(
    BuildContext context,
    String title,
    IconData icon,
    String link,
    bool showLink,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, size: 24, color: const Color(0xFF0ABAB5)),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(
                    showLink ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF0ABAB5),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showLink)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            child: InkWell(
              onTap: () async {
                if (await canLaunch(link)) {
                  await launch(link);
                }
              },
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: link));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Link copied to clipboard')),
                );
              },
              child: Text(
                link,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Widget for Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0ABAB5),
      ),
    );
  }

  // Widget for Section Content
  Widget _buildSectionContent(String content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Widget for Team Member Card
  Widget _buildTeamMemberCard(String name, String id) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.person, size: 20, color: const Color(0xFF0ABAB5)),
            SizedBox(width: 8),
            Text(
              'Name: $name',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Text(
              'ID: $id',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:insight/body/Project_class.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ProjectDetailsPage extends StatelessWidget {
//   final Project project;
//
//   ProjectDetailsPage({required this.project});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEEFCFC), // Set background color
//       appBar: AppBar(
//         title: Text(
//           project.projectName,
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF0ABAB5), // AppBar color
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Project Overview Card
//             _buildOverviewCard(context),
//             SizedBox(height: 20),
//
//             // Links Section
//             _buildLinkSection(context, 'GitHub Link', project.githubLink),
//             SizedBox(height: 16),
//             _buildLinkSection(context, 'Doc Link', project.DocLink),
//             SizedBox(height: 20),
//
//             // Description Section
//             _buildSectionTitle('Description'),
//             _buildSectionContent(project.description),
//             SizedBox(height: 20),
//
//             // Team Members Section
//             _buildSectionTitle('Team Members'),
//             ...project.teamMembers.map((member) {
//               return _buildTeamMemberCard(member['name']!, member['id']!);
//             }).toList(),
//             SizedBox(height: 20),
//
//             // Tags Section
//             _buildSectionTitle('Tags'),
//             Wrap(
//               spacing: 8,
//               children: project.tags.map((tag) => Chip(
//                 label: Text(tag),
//                 backgroundColor: const Color(0xFF0ABAB5).withOpacity(0.2),
//                 labelStyle: TextStyle(color: const Color(0xFF0ABAB5)),
//               )).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget for Project Overview Card
//   Widget _buildOverviewCard(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildInfoRow(Icons.category, 'Category', project.category),
//             SizedBox(height: 12),
//             _buildInfoRow(Icons.supervisor_account, 'Supervisor', project.supervisorName),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget for Info Row with Icon
//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: const Color(0xFF0ABAB5)),
//         SizedBox(width: 8),
//         Text(
//           '$label: ',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           value,
//           style: TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }
//
//   // Widget for Link Section
//   Widget _buildLinkSection(BuildContext context, String title, String link) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '$title:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             InkWell(
//               onTap: () async {
//                 if (await canLaunch(link)) {
//                   await launch(link);
//                 }
//               },
//               onLongPress: () {
//                 Clipboard.setData(ClipboardData(text: link));
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('$title copied to clipboard')),
//                 );
//               },
//               child: Text(
//                 link,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.blue,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget for Section Title
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: const Color(0xFF0ABAB5),
//       ),
//     );
//   }
//
//   // Widget for Section Content
//   Widget _buildSectionContent(String content) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(
//           content,
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
//
//   // Widget for Team Member Card
//   Widget _buildTeamMemberCard(String name, String id) {
//     return Card(
//       elevation: 4,
//       margin: EdgeInsets.symmetric(vertical: 4),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           children: [
//             Icon(Icons.person, size: 20, color: const Color(0xFF0ABAB5)),
//             SizedBox(width: 8),
//             Text(
//               'Name: $name',
//               style: TextStyle(fontSize: 16),
//             ),
//             Spacer(),
//             Text(
//               'ID: $id',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:insight/body/Project_class.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ProjectDetailsPage extends StatelessWidget {
//   final Project project;
//
//   ProjectDetailsPage({required this.project});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(project.projectName),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Project Name: ${project.projectName}',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Text('Category: ${project.category}',
//                 style: TextStyle(fontSize: 16)),
//             SizedBox(height: 8),
//             Text('Supervisor: ${project.supervisorName}',
//                 style: TextStyle(fontSize: 16)),
//             SizedBox(height: 8),
//             _buildLinkSection(context, 'GitHub Link', project.githubLink),
//             SizedBox(height: 8),
//             _buildLinkSection(context, 'Doc Link', project.DocLink),
//             SizedBox(height: 8),
//             Text('Description:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             Text(project.description, style: TextStyle(fontSize: 14)),
//             SizedBox(height: 8),
//             Text('Team Members:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             ...project.teamMembers.map((member) {
//               return Text('Name: ${member['name']}, ID: ${member['id']}');
//             }).toList(),
//             SizedBox(height: 8),
//             Text('Tags:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             Wrap(
//               children: project.tags.map((tag) => Chip(label: Text(tag))).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLinkSection(BuildContext context, String title, String link) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('$title:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         InkWell(
//           onTap: () async {
//             if (await canLaunch(link)) {
//               await launch(link);
//             }
//           },
//           onLongPress: () {
//             Clipboard.setData(ClipboardData(text: link));
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('$title copied to clipboard')),
//             );
//           },
//           child: Text(
//             link,
//             style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
//           ),
//         ),
//       ],
//     );
//   }
// }
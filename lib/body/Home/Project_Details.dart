// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insight/body/Project_class.dart';
import 'package:insight/body/databseViewModel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'myHomePage.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool _showGitHubLink = false;
  bool _showDocLink = false;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final projectViewModel =
        Provider.of<ProjectViewModel>(context, listen: false);
    bool favStat = await projectViewModel.isFavoriteProject(widget.project.id);
    setState(() {
      isFavorite = favStat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEFCFC),
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Description'),
                _buildSectionContent(widget.project.description),
                const SizedBox(height: 20),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 20),
                _buildSectionTitle('Supervisor'),
                _buildsuperVisorCard(widget.project.supervisorName),
                const SizedBox(height: 20),
                _buildSectionTitle('Team Members'),
                ...widget.project.teamMembers.map((member) {
                  return _buildTeamMemberCard(member['name']!, member['id']!);
                }),
                const SizedBox(height: 20),
                _buildSectionTitle('Category'),
                _buildInfoRow(
                    Icons.category, 'Category', widget.project.category),
                const SizedBox(height: 20),
                _buildSectionTitle('Tags'),
                Wrap(
                  spacing: 8,
                  children: widget.project.tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor:
                                const Color(0xFF0ABAB5).withOpacity(0.2),
                            labelStyle:
                                const TextStyle(color: Color(0xFF0ABAB5)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
              backgroundColor: const Color.fromARGB(255, 10, 186, 180),
              child: Image.asset(
                'assets/icons/chatbot2.png',
                width: 45,
                height: 45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.project.projectName,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF0ABAB5), // AppBar color
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: Icon(isFavorite ? Icons.delete : Icons.favorite_border),
          onPressed: () => _showConfirmationDialog(context),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isFavorite ? Colors.red.shade50 : Colors.green.shade50,
          title: Text(
            isFavorite ? 'Remove from Favorites?' : 'Add to Favorites?',
            style: TextStyle(
                color: isFavorite ? Colors.redAccent : Colors.green,
                fontWeight: FontWeight.bold),
          ),
          content: Text(isFavorite
              ? 'Are you sure you want to remove this project from favorites?'
              : 'Are you sure you want to add this project to favorites?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final projectViewModel =
                    Provider.of<ProjectViewModel>(context, listen: false);
                if (isFavorite) {
                  await projectViewModel.removeFavoriteProject(
                      widget.project.id, context);
                } else {
                  await projectViewModel.addFavoriteProject(
                      widget.project.id, context);
                }
                _checkFavorite();
              },
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: isFavorite ? Colors.red : Colors.teal),
              child: Text(isFavorite ? 'Remove' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0ABAB5)),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

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
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
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
                final Uri url = Uri.parse(link);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open link')),
                  );
                }
              },
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: link));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link copied to clipboard')),
                );
              },
              child: Text(
                link,
                style: const TextStyle(
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0ABAB5),
      ),
    );
  }

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
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(String name, String id) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.supervised_user_circle,
                size: 20, color: Color(0xFF0ABAB5)),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Text(
              id,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildsuperVisorCard(String name) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.person, size: 20, color: Color(0xFF0ABAB5)),
            const SizedBox(width: 8),
            Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

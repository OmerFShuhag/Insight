import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insight/body/Project_class.dart';
import 'package:insight/body/databseViewModel.dart';
import 'package:provider/provider.dart';
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
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final projectViewModel =
        Provider.of<ProjectViewModel>(context, listen: false);
    bool favStat = await projectViewModel.isFavoriteProject(
        widget.project.UserId, widget.project.id);
    setState(() {
      isFavorite = favStat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEFCFC), // Set background color
      appBar: _buildappbar(context),
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

  AppBar _buildappbar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.project.projectName,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF0ABAB5), // AppBar color
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: Icon(isFavorite ? Icons.delete : Icons.favorite_border),
          onPressed: () => _showconfirmationDialog(context),
        ),
      ],
    );
  }

  _showconfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(isFavorite ? 'Remove from Favorites?' : 'Add to Favorites?'),
          content: Text(isFavorite
              ? 'Are you sure you want to remove this project from favorites?'
              : 'Are you sure you want to add this project to favorites?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final projectViewModel =
                    Provider.of<ProjectViewModel>(context, listen: false);
                if (isFavorite) {
                  await projectViewModel.removeFavoriteProject(
                      widget.project.UserId, widget.project.id, context);
                } else {
                  await projectViewModel.addFavoriteProject(
                      widget.project.UserId, widget.project.id, context);
                }
                _checkFavorite();
              },
              child: Text(isFavorite ? 'Remove' : 'Add'),
            ),
          ],
        );
      },
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

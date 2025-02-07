import 'dart:math';
import 'package:flutter/material.dart';
import 'package:insight/body/Project_class.dart';
import 'package:insight/body/Home/Project_Details.dart';

class ProjectListView extends StatelessWidget {
  final List<Project> projects;

  const ProjectListView({Key? key, required this.projects}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return ProjectCard(project: project);
        },
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({Key? key, required this.project}) : super(key: key);

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
      Colors.green[50]!,
      const Color(0xFFA4E3DA),
      Colors.pink[50]!,
      Colors.green[100]!,
      Colors.blue[100]!,
      Colors.teal[50]!,
      Colors.red[50]!,
      Colors.red[100]!,
      Colors.yellow[50]!,
      Colors.grey[100]!,
      const Color(0xFFB8B3FF),
      const Color(0xFFF1D3CE),
      const Color(0xFF79B8F4),
      const Color(0xFFF1D6E7),
      const Color(0xFFAE9ACB),
      const Color(0xFFB6E8FB),
      const Color(0xFFDBC9F5),
      const Color(0xFFB4FCF2),
      const Color(0xFFECCBD9),
      const Color(0xFF80FFE8),
      const Color(0xFFFACFCF),
      const Color(0xFFD3E4EB),
      const Color(0xFFCFC6D7),
      const Color(0xFFCDE9F3),
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(14),
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (_isExpanded)
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 17.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.project.description,
                        style: const TextStyle(
                          color: Color(0xFF353D3D),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
                            backgroundColor: const Color(0xFFC6EFEE),
                            shape: const StadiumBorder(
                              side: BorderSide(color: Color(0xFF0ABAB5)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0ABAB5),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProjectDetailsPage(project: widget.project),
                            ),
                          );
                        },
                        child: const Text(
                          'View Full Project Info',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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

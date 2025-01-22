import 'package:flutter/material.dart';
import 'package:insight/body/Home/AddProject.dart';
import 'package:insight/body/Home/AllProjects.dart';
import 'package:insight/body/Home/MyProjects.dart';
import 'package:insight/body/Home/Catagories.dart';
import 'package:insight/body/Home/AddProject.dart';
import 'package:insight/body/bottom_bar/demo.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Project Dashboard',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Manage your projects, view favorites, and add new ones easily.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Spacer(),
          // Cards section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // First row of two cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomCard(
                        title: 'All Projects',
                        description:
                            'View all your current and completed projects.',
                        icon: Icons.view_list,
                        onTap: () {
                          print("All Projects");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectsPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomCard(
                        title: 'My Projects',
                        description:
                            'Manage and track the progress of your own projects.',
                        icon: Icons.assignment_turned_in,
                        onTap: () {
                          print("My Projects");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyProjects(
                                userId: '',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Second row of two cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomCard(
                        title: 'Category',
                        description:
                            'Browse through various categories of projects.',
                        icon: Icons.category,
                        onTap: () {
                          // Handle tap
                          print("Category");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriesPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomCard(
                        title: 'Add Project',
                        description:
                            'Add a new project and start working on it right away.',
                        icon: Icons.add,
                        onTap: () {
                          print("Add Project");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProjectPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Function() onTap;

  CustomCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width / 2 - 40,
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Color.fromARGB(255, 10, 186, 180)),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

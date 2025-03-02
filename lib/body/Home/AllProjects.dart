import 'package:flutter/material.dart';
import 'package:insight/body/Project_list.dart';
import 'package:provider/provider.dart';
import 'package:insight/body/databseViewModel.dart';
import 'myHomePage.dart';

class AllProjectsPage extends StatefulWidget {
  const AllProjectsPage({super.key});

  @override
  _AllProjectsPageState createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProjectViewModel>(context, listen: false).fetchAllProjects();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Projects',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 10, 186, 180),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Projects',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.teal, width: 2)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.teal, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.teal.shade50,
                  ),
                ),
              ),
              Expanded(
                child: Consumer<ProjectViewModel>(
                  builder: (context, projectViewModel, child) {
                    if (projectViewModel.projects.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final filteredProjects =
                        projectViewModel.projects.where((project) {
                      return project.projectName
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase());
                    }).toList();

                    if (filteredProjects.isEmpty) {
                      return const Center(
                        child: Text(
                          'No projects found.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }

                    return ProjectListView(projects: filteredProjects);
                  },
                ),
              ),
            ],
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
}

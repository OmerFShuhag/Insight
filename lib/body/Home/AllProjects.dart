import 'package:flutter/material.dart';
import 'package:insight/body/Project_list.dart';
import 'package:provider/provider.dart';
import 'package:insight/body/databseViewModel.dart';

class AllProjectsPage extends StatefulWidget {
  @override
  _AllProjectsPageState createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  TextEditingController _searchController = TextEditingController();
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
        title: Text('All Projects',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 10, 186, 180),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                //labelText: 'Search Projects',
                hintText: 'Search Projects',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.teal, width: 2)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.teal, width: 2),
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
                  return Center(child: CircularProgressIndicator());
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
    );
  }
}

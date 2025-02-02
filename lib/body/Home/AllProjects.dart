import 'package:flutter/material.dart';
import 'package:insight/body/Project_list.dart';
import 'package:provider/provider.dart';
import 'package:insight/body/databseViewModel.dart';
import 'package:insight/body/Project_class.dart';
import 'package:insight/body/Home/Project_Details.dart';

class AllProjectsPage extends StatefulWidget {
  @override
  _AllProjectsPageState createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProjectViewModel>(context, listen: false).fetchAllProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Projects'),
      ),
      body: Consumer<ProjectViewModel>(
        builder: (context, projectViewModel, child) {
          if (projectViewModel.projects.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          if (projectViewModel.projects.isEmpty) {
            return const Center(
              child: Text(
                'No projects available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ProjectListView(projects: projectViewModel.projects);
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insight/body/Project_list.dart';
import 'package:insight/body/databseViewModel.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    Provider.of<ProjectViewModel>(context, listen: false)
        .fetchFavoriteProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Consumer<ProjectViewModel>(
        builder: (context, projectViewModel, child) {
          if (projectViewModel.favoriteProjects.isEmpty) {
            return const Center(
              child: Text(
                'No favorite projects available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ProjectListView(projects: projectViewModel.favoriteProjects);
        },
      ),
    );
  }
}

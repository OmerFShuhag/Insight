import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insight/body/Project_list.dart';
import 'package:insight/body/databseViewModel.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  final String userId;

  const Favorite({super.key, required this.userId});
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      var userId;
      Provider.of<ProjectViewModel>(context, listen: false)
          .fetchFavoriteProjects(userId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<ProjectViewModel>(
        builder: (context, projectViewModel, child) {
          if (projectViewModel.favoriteProjects.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
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

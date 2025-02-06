import 'package:flutter/material.dart';
import 'package:insight/body/Project_list.dart';
import 'package:insight/body/databseViewModel.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _loadInitialData() {
    Provider.of<ProjectViewModel>(context, listen: false)
        .fetchFavoriteProjects();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
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
                final filteredFavorites =
                    projectViewModel.favoriteProjects.where((project) {
                  return project.projectName
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                }).toList();

                if (filteredFavorites.isEmpty) {
                  return const Center(
                    child: Text(
                      'No favorite projects found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ProjectListView(projects: filteredFavorites);
              },
            ),
          ),
        ],
      ),
    );
  }
}

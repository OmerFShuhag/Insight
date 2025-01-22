import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.shopping_cart, 'name': 'E-commerce'},
    {'icon': Icons.school, 'name': 'Education / e-learning'},
    {'icon': Icons.style, 'name': 'Lifestyle'},
    {'icon': Icons.movie, 'name': 'Entertainment'},
    {'icon': Icons.event, 'name': 'Ticket-booking'},
    {'icon': Icons.videogame_asset, 'name': 'Game'},
    {'icon': Icons.fitness_center, 'name': 'Health & fitness'},
    {'icon': Icons.work, 'name': 'Productivity'},
    {'icon': Icons.travel_explore, 'name': 'Travel'},
    {'icon': Icons.local_hospital, 'name': 'Medical'},
    {'icon': Icons.article, 'name': 'News'},
    {'icon': Icons.people, 'name': 'Social media'},
    {'icon': Icons.self_improvement, 'name': 'Self care'},
    {'icon': Icons.more_horiz, 'name': 'Other'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 10, 186, 180),
      ),
      body: CategoriesGrid(categories: categories),
    );
  }
}

class CategoriesGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const CategoriesGrid({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryItem(
          icon: categories[index]['icon'],
          name: categories[index]['name'],
          onTap: () {
            // Handle on tap
            print('Tapped on ${categories[index]['name']}');
          },
        );
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.icon,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5.0,
        color: Color.fromARGB(255, 183, 248, 246),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 116, 240, 236),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 181, 8, 197).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50.0,
                color: Colors.blueGrey.shade700, // Icon color
              ),
              const SizedBox(height: 10.0),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 0, 0, 0), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

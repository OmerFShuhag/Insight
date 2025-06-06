import 'package:flutter/material.dart';
import 'CategoryProjectPage.dart';
import 'myHomePage.dart';

class CategoriesPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'icon': 'assets/icons/ecommerce.png',
      'name': 'E-Commerce',
      'color': Colors.blue[50]
    },
    {
      'icon': 'assets/icons/elearning.png',
      'name': 'Education/E-learning',
      'color': Colors.green[50]
    },
    {
      'icon': 'assets/icons/daily-tasks.png',
      'name': 'Lifestyle',
      'color': const Color(0xFFA4E3DA)
    },
    {
      'icon': 'assets/icons/movie.png',
      'name': 'Entertainment',
      'color': Colors.pink[50]
    },
    {
      'icon': 'assets/icons/ticket_booking.png',
      'name': 'Ticket-Booking',
      'color': Colors.green[80]
    },
    {
      'icon': 'assets/icons/game-console.png',
      'name': 'Game',
      'color': Colors.blue[50]
    },
    {
      'icon': 'assets/icons/healthcare.png',
      'name': 'Health & Fitness',
      'color': Colors.purple[50]
    },
    {
      'icon': 'assets/icons/productivity.png',
      'name': 'Productivity',
      'color': Colors.teal[50]
    },
    {
      'icon': 'assets/icons/travel.png',
      'name': 'Travel',
      'color': Colors.blueGrey[50]
    },
    {
      'icon': 'assets/icons/medical-team.png',
      'name': 'Medical',
      'color': Colors.red[50]
    },
    {
      'icon': 'assets/icons/online-news.png',
      'name': 'News',
      'color': Colors.yellow[50]
    },
    {
      'icon': 'assets/icons/bullhorn.png',
      'name': 'Social Media',
      'color': Colors.orange[50]
    },
    {
      'icon': 'assets/icons/shampoo.png',
      'name': 'Self-Care',
      'color': Colors.purple[50]
    },
    {
      'icon': 'assets/icons/application.png',
      'name': 'Others',
      'color': Colors.grey[100]
    },
  ];

CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0ABAB5),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _navigateToCategoryProjects(
                  context, categories[index]['name']),
              child: CategoryCard(
                iconPath: categories[index]['icon'],
                name: categories[index]['name'],
                backgroundColor: categories[index]['color'],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          },
          backgroundColor: const Color.fromARGB(255, 10, 186, 180),
          child:
              Image.asset('assets/icons/chatbot2.png', width: 45, height: 45),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _navigateToCategoryProjects(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProjectsPage(category: category),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String iconPath;
  final String name;
  final Color? backgroundColor;

  const CategoryCard({
    super.key,
    required this.iconPath,
    required this.name,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              height: 50.0,
              width: 50.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

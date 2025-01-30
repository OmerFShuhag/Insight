class User_class {
  String name;
  String id;
  String semester;
  int year;
  List<String> createdProjects;
  List<String> favoriteProjects;

  User_class({
    required this.id,
    required this.name,
    required this.semester,
    required this.year,
    required this.createdProjects,
    required this.favoriteProjects,
  });

  factory User_class.fromMap(Map<String, dynamic> data) {
    return User_class(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      semester: data['semester'] ?? 'Spring',
      year: data['year'] ?? 2010,
      createdProjects: List<String>.from(data['createdProjects'] ?? []),
      favoriteProjects: List<String>.from(data['favoriteProjects'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'semester': semester,
      'year': year,
      'createdProjects': createdProjects,
      'favoriteProjects': favoriteProjects,
    };
  }
}

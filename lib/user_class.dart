class User_class {
  String name;
  String id;
  String semester;
  int year;
  int batch;

  User_class({
    required this.id,
    required this.name,
    required this.semester,
    required this.year,
    required this.batch,
  });

  factory User_class.fromMap(Map<String, dynamic> data) {
    return User_class(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      semester: data['semester'] ?? 'Spring',
      year: data['year'] ?? 2010,
      batch: data['batch'] ?? 40,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'semester': semester,
      'year': year,
      'batch': batch,
    };
  }
}

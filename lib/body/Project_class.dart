class Project {
  String id;
  String projectName;
  String description;
  String category;
  List<Map<String, String>> teamMembers;
  String supervisorName;
  String githubLink;
  List<String> tags;

  Project({
    required this.id,
    required this.projectName,
    required this.description,
    required this.category,
    required this.teamMembers,
    required this.supervisorName,
    required this.githubLink,
    required this.tags,
  });

  //project object convert kormu firestore o save korar lagi
  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
      'description': description,
      'category': category,
      'teamMembers': teamMembers,
      'supervisorName': supervisorName,
      'githubLink': githubLink,
      'tags': tags,
    };
  }

  // object Firestore document snapshot or lagi
  factory Project.fromMap(String id, Map<String, dynamic> map) {
    List<Map<String, String>> teamMembers = [];
    if (map['teamMembers'] != null) {
      teamMembers = List<Map<String, String>>.from(
        map['teamMembers'].map((item) => Map<String, String>.from(item)),
      );
    }

    List<String> tags = List<String>.from(map['tags'] ?? []);

    return Project(
      id: id,
      projectName: map['projectName'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      teamMembers: teamMembers,
      supervisorName: map['supervisorName'] ?? '',
      githubLink: map['githubLink'] ?? '',
      tags: tags,
    );
  }
}

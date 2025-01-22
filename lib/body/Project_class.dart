class Project {
  String id;
  String projectName;
  String description;
  String category;
  List<Map<String, String>>
      teamMembers; // List of team members with their name and ID
  String supervisorName;
  String githubLink;
  List<String> tags; // List of selected tags like android, web, etc.

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

  // Convert a Project object to a Map for saving to Firestore
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

  // Create a Project object from a Firestore document snapshot
  factory Project.fromMap(String id, Map<String, dynamic> map) {
    // Safely cast or process the teamMembers field
    List<Map<String, String>> teamMembers = [];
    if (map['teamMembers'] != null) {
      teamMembers = List<Map<String, String>>.from(
        map['teamMembers'].map((item) => Map<String, String>.from(item)),
      );
    }

    // Similarly for other fields
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

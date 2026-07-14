class StudentModel {
  final String _uid;
  final String _name;
  final String _email;
  final String _programme; 
  final int _graduationYear; 
  final double _cgpa;
  final int _activeBacklogs;
  final List<String> _skills;

  StudentModel({
    required String uid,
    required String name,
    required String email,
    required String programme,
    required int graduationYear,
    required double cgpa,
    required int activeBacklogs,
    required List<String> skills,
  })  : _uid = uid,
        _name = name,
        _email = email,
        _programme = programme,
        _graduationYear = graduationYear,
        _cgpa = cgpa,
        _activeBacklogs = activeBacklogs,
        _skills = skills;

  // Getters to protect state (Encapsulation)
  String get uid => _uid;
  String get name => _name;
  String get email => _email;
  String get programme => _programme;
  int get graduationYear => _graduationYear;
  double get cgpa => _cgpa;
  int get activeBacklogs => _activeBacklogs;
  List<String> get skills => List.unmodifiable(_skills); // Prevents outside modification

  // Convert from Firestore Document to Dart Object
  factory StudentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return StudentModel(
      uid: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      programme: map['programme'] ?? '',
      graduationYear: map['graduationYear']?.toInt() ?? 0,
      cgpa: map['cgpa']?.toDouble() ?? 0.0,
      activeBacklogs: map['activeBacklogs']?.toInt() ?? 0,
      skills: List<String>.from(map['skills'] ?? []),
    );
  }

  // Convert from Dart Object to Firestore JSON
  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'email': _email,
      'programme': _programme,
      'graduationYear': _graduationYear,
      'cgpa': _cgpa,
      'activeBacklogs': _activeBacklogs,
      'skills': _skills,
      'profileCompleted': true,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
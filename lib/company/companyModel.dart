class CompanyModel {
  final String _id;
  final String _name;
  final String _sector;
  final String _description;
  final String _website;

  CompanyModel({
    required String id,
    required String name,
    required String sector,
    required String description,
    required String website,
  })  : _id = id,
        _name = name,
        _sector = sector,
        _description = description,
        _website = website;

  // Getters to protect state (Strict Encapsulation)
  String get id => _id;
  String get name => _name;
  String get sector => _sector;
  String get description => _description;
  String get website => _website;

  // Convert from Firestore Document to Dart Object
  factory CompanyModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CompanyModel(
      id: documentId,
      name: map['name'] ?? '',
      sector: map['sector'] ?? '',
      description: map['description'] ?? '',
      website: map['website'] ?? '',
    );
  }

  // Convert from Dart Object to Firestore JSON
  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'sector': _sector,
      'description': _description,
      'website': _website,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
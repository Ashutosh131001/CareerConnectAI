class PlacementDriveModel {
  final String _id;
  final String _companyId;
  final String _companyName; // Stored here to save extra reads when displaying
  final String _jobRole;
  final double _ctc; // Cost to Company (Package in LPA)
  final DateTime _deadline;
  
  // Eligibility Criteria
  final double _minCgpa;
  final int _maxActiveBacklogs;
  final List<String> _requiredSkills;

  PlacementDriveModel({
    required String id,
    required String companyId,
    required String companyName,
    required String jobRole,
    required double ctc,
    required DateTime deadline,
    required double minCgpa,
    required int maxActiveBacklogs,
    required List<String> requiredSkills,
  })  : _id = id,
        _companyId = companyId,
        _companyName = companyName,
        _jobRole = jobRole,
        _ctc = ctc,
        _deadline = deadline,
        _minCgpa = minCgpa,
        _maxActiveBacklogs = maxActiveBacklogs,
        _requiredSkills = requiredSkills;

  // Getters for Strict Encapsulation
  String get id => _id;
  String get companyId => _companyId;
  String get companyName => _companyName;
  String get jobRole => _jobRole;
  double get ctc => _ctc;
  DateTime get deadline => _deadline;
  double get minCgpa => _minCgpa;
  int get maxActiveBacklogs => _maxActiveBacklogs;
  List<String> get requiredSkills => List.unmodifiable(_requiredSkills);

  // Convert from Firestore
  factory PlacementDriveModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PlacementDriveModel(
      id: documentId,
      companyId: map['companyId'] ?? '',
      companyName: map['companyName'] ?? '',
      jobRole: map['jobRole'] ?? '',
      ctc: (map['ctc'] ?? 0.0).toDouble(),
      deadline: DateTime.parse(map['deadline'] ?? DateTime.now().toIso8601String()),
      minCgpa: (map['minCgpa'] ?? 0.0).toDouble(),
      maxActiveBacklogs: map['maxActiveBacklogs'] ?? 0,
      requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
    );
  }

  // Convert to Firestore JSON
  Map<String, dynamic> toMap() {
    return {
      'companyId': _companyId,
      'companyName': _companyName,
      'jobRole': _jobRole,
      'ctc': _ctc,
      'deadline': _deadline.toIso8601String(),
      'minCgpa': _minCgpa,
      'maxActiveBacklogs': _maxActiveBacklogs,
      'requiredSkills': _requiredSkills,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
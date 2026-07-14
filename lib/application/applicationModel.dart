class ApplicationModel {
  final String _id;
  final String _studentId;
  final String _driveId;
  final String _companyName; // Stored here for fast UI loading
  final String _jobRole;
  final String _status; // e.g., 'Pending', 'Interview', 'Selected', 'Rejected'
  final DateTime _appliedAt;

  ApplicationModel({
    required String id,
    required String studentId,
    required String driveId,
    required String companyName,
    required String jobRole,
    required String status,
    required DateTime appliedAt,
  })  : _id = id,
        _studentId = studentId,
        _driveId = driveId,
        _companyName = companyName,
        _jobRole = jobRole,
        _status = status,
        _appliedAt = appliedAt;

  // Strict Encapsulation Getters
  String get id => _id;
  String get studentId => _studentId;
  String get driveId => _driveId;
  String get companyName => _companyName;
  String get jobRole => _jobRole;
  String get status => _status;
  DateTime get appliedAt => _appliedAt;

  // From Firestore
  factory ApplicationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ApplicationModel(
      id: documentId,
      studentId: map['studentId'] ?? '',
      driveId: map['driveId'] ?? '',
      companyName: map['companyName'] ?? '',
      jobRole: map['jobRole'] ?? '',
      status: map['status'] ?? 'Pending',
      appliedAt: DateTime.parse(map['appliedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // To Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': _studentId,
      'driveId': _driveId,
      'companyName': _companyName,
      'jobRole': _jobRole,
      'status': _status,
      'appliedAt': _appliedAt.toIso8601String(),
    };
  }
}
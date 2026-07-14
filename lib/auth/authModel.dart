// lib/features/auth/models/user_model.dart

enum UserRole { student, admin }

class UserModel {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.student,
      ),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
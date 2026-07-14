import 'package:careerconnect/student/studentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// The Interface (Abstraction)
abstract class StudentRepository {
  Future<void> saveStudentProfile(StudentModel student);
  Future<StudentModel?> getStudentProfile(String uid);
  Future<void> updateStudentProfile(String uid, Map<String, dynamic> updatedData);
}

class FirebaseStudentRepository implements StudentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveStudentProfile(StudentModel student) async {
    try {
      await _firestore
          .collection('users')
          .doc(student.uid)
          .set(student.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save student profile: $e');
    }
  }

  @override
  Future<StudentModel?> getStudentProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return StudentModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch student profile: $e');
    }
  }
  // Add this to your existing repository class
Future<void> updateStudentProfile(String uid, Map<String, dynamic> updatedData) async {
  try {
    // SetOptions(merge: true) ensures we only update the fields provided in the map
    // and leave everything else (like role or email) completely intact.
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      updatedData, 
      SetOptions(merge: true),
    );
  } catch (e) {
    throw Exception('Failed to update profile: $e');
  }
}
}

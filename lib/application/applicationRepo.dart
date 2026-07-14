import 'package:careerconnect/application/applicationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ApplicationRepository {
  Future<void> submitApplication(ApplicationModel application);
  Future<List<ApplicationModel>> getApplicationsForStudent(String studentId);
  Future<bool> hasStudentApplied(String studentId, String driveId);
  Future<List<ApplicationModel>> getAllApplications();
  Future<void> updateApplicationStatus(String applicationId, String newStatus);
}

class FirebaseApplicationRepository implements ApplicationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> submitApplication(ApplicationModel application) async {
    try {
      if (application.id.isEmpty) {
        await _firestore.collection('applications').add(application.toMap());
      } else {
        await _firestore
            .collection('applications')
            .doc(application.id)
            .set(application.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception('Failed to submit application: $e');
    }
  }

  @override
  Future<List<ApplicationModel>> getApplicationsForStudent(
    String studentId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('applications')
          .where('studentId', isEqualTo: studentId)
          .orderBy('appliedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ApplicationModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch applications: $e');
    }
  }

  @override
  Future<bool> hasStudentApplied(String studentId, String driveId) async {
    try {
      final snapshot = await _firestore
          .collection('applications')
          .where('studentId', isEqualTo: studentId)
          .where('driveId', isEqualTo: driveId)
          .get();
      // If the query returns any documents, they have already applied
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check application status: $e');
    }
  }

  @override
  Future<List<ApplicationModel>> getAllApplications() async {
    try {
      // Fetches all applications across all drives, newest first
      final snapshot = await _firestore
          .collection('applications')
          .orderBy('appliedAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ApplicationModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch all applications: $e');
    }
  }

  @override
  Future<void> updateApplicationStatus(
    String applicationId,
    String newStatus,
  ) async {
    try {
      await _firestore.collection('applications').doc(applicationId).update({
        'status': newStatus,
      });
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }
}

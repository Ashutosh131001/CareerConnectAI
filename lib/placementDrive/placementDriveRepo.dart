import 'package:careerconnect/placementDrive/placementdriveModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


abstract class DriveRepository {
  Future<void> saveDrive(PlacementDriveModel drive);
  Future<List<PlacementDriveModel>> getAllDrives();
  Future<List<PlacementDriveModel>> getDrivesForCompany(String companyId);
}

class FirebaseDriveRepository implements DriveRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveDrive(PlacementDriveModel drive) async {
    try {
      if (drive.id.isEmpty) {
        await _firestore.collection('drives').add(drive.toMap());
      } else {
        await _firestore.collection('drives').doc(drive.id).set(drive.toMap(), SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception('Failed to save placement drive: $e');
    }
  }

  @override
  Future<List<PlacementDriveModel>> getAllDrives() async {
    try {
      // Order by closest deadline first
      final snapshot = await _firestore.collection('drives')
          .orderBy('deadline')
          .get();
      return snapshot.docs
          .map((doc) => PlacementDriveModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch drives: $e');
    }
  }

  @override
  Future<List<PlacementDriveModel>> getDrivesForCompany(String companyId) async {
    try {
      final snapshot = await _firestore.collection('drives')
          .where('companyId', isEqualTo: companyId)
          .get();
      return snapshot.docs
          .map((doc) => PlacementDriveModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch company drives: $e');
    }
  }
}
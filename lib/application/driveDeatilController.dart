import 'package:careerconnect/application/applicationModel.dart';
import 'package:careerconnect/application/applicationRepo.dart';
import 'package:careerconnect/placementDrive/placementdriveModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriveDetailController extends GetxController {
  final ApplicationRepository _appRepo;
  final PlacementDriveModel drive; // The specific drive the student clicked on

  final FirebaseAuth _auth = FirebaseAuth.instance;

  DriveDetailController(this._appRepo, this.drive);

  final RxBool isLoading = false.obs;
  final RxBool hasApplied = false.obs;
  final RxBool isCheckingStatus = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkApplicationStatus();
  }

  Future<void> _checkApplicationStatus() async {
    final studentId = _auth.currentUser?.uid;
    if (studentId == null) return;

    try {
      isCheckingStatus.value = true;
      // Ask the repository if a record already exists
      hasApplied.value = await _appRepo.hasStudentApplied(studentId, drive.id);
    } catch (e) {
      Get.snackbar('Error', 'Could not verify application status.');
    } finally {
      isCheckingStatus.value = false;
    }
  }

  Future<void> applyForDrive() async {
    final studentId = _auth.currentUser?.uid;
    if (studentId == null) {
      Get.snackbar('Error', 'You must be logged in to apply.');
      return;
    }

    try {
      isLoading.value = true;

      // 1. FETCH STUDENT PROFILE FROM FIRESTORE
      final studentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(studentId)
          .get();

      if (!studentDoc.exists) {
        Get.snackbar(
          'Error',
          'Student profile not found. Please complete your profile.',
        );
        return;
      }

      final studentData = studentDoc.data() as Map<String, dynamic>;

      // Safely parse the student's stats (assuming you saved these during Student Setup)
      final double studentCgpa = (studentData['cgpa'] ?? 0.0).toDouble();
      final int studentBacklogs = studentData['activeBacklogs'] ?? 0;

      // 2. THE ELIGIBILITY CHECK
      if (studentCgpa < drive.minCgpa) {
        Get.snackbar(
          'Not Eligible',
          'Your CGPA ($studentCgpa) is below the required ${drive.minCgpa}.',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return; // STOPS THE APPLICATION
      }

      if (studentBacklogs > drive.maxActiveBacklogs) {
        Get.snackbar(
          'Not Eligible',
          'You have $studentBacklogs active backlogs. Maximum allowed is ${drive.maxActiveBacklogs}.',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return; // STOPS THE APPLICATION
      }

      // 3. IF THEY PASS, SUBMIT THE APPLICATION
      final application = ApplicationModel(
        id: '',
        studentId: studentId,
        driveId: drive.id,
        companyName: drive.companyName,
        jobRole: drive.jobRole,
        status: 'Pending',
        appliedAt: DateTime.now(),
      );

      await _appRepo.submitApplication(application);

      hasApplied.value = true;
      Get.snackbar(
        'Success!',
        'Your application for ${drive.companyName} has been submitted.',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit application: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

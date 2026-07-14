import 'package:careerconnect/student/studentRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Update path to match your project

// import '../../student/student_repository.dart'; 

class ProfileController extends GetxController {
  final StudentRepository _studentRepo; 
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ProfileController(this._studentRepo);

  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;

  // Form Controllers matched to your model
  final TextEditingController nameController = TextEditingController();
  final TextEditingController programmeController = TextEditingController();
  final TextEditingController graduationYearController = TextEditingController();
  final TextEditingController cgpaController = TextEditingController();
  final TextEditingController backlogsController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      isLoading.value = true;
      final student = await _studentRepo.getStudentProfile(uid); 
      
      if (student != null) {
        nameController.text = student.name;
        programmeController.text = student.programme;
        graduationYearController.text = student.graduationYear == 0 ? '' : student.graduationYear.toString();
        cgpaController.text = student.cgpa.toString();
        backlogsController.text = student.activeBacklogs.toString();
        // Convert the List<String> to a comma-separated string for the text field
        skillsController.text = student.skills.join(', ');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile data.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      isSaving.value = true;

      // Safely parse numerical values
      final int gradYear = int.tryParse(graduationYearController.text.trim()) ?? 0;
      final double cgpa = double.tryParse(cgpaController.text.trim()) ?? 0.0;
      final int backlogs = int.tryParse(backlogsController.text.trim()) ?? 0;
      
      // Convert comma-separated string back to List<String>
      final List<String> skillsList = skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // Pack ONLY the fields the student is allowed to change.
      final Map<String, dynamic> updatedData = {
        'name': nameController.text.trim(),
        'programme': programmeController.text.trim(),
        'graduationYear': gradYear,
        'cgpa': cgpa,
        'activeBacklogs': backlogs,
        'skills': skillsList,
        'updatedAt': DateTime.now().toIso8601String(), // Keep tracking updates
      };

      await _studentRepo.updateStudentProfile(uid, updatedData);

      Get.snackbar(
        'Success', 
        'Profile updated successfully!',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Could not save profile: $e');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    programmeController.dispose();
    graduationYearController.dispose();
    cgpaController.dispose();
    backlogsController.dispose();
    skillsController.dispose();
    super.onClose();
  }
}
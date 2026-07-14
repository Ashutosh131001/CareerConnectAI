import 'package:careerconnect/student/studentModel.dart';
import 'package:careerconnect/student/studentRepo.dart';
import 'package:careerconnect/studentDashboard/studentDashBoardVeiw.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentProfileController extends GetxController {
  // Inject the repository through the constructor to maintain decoupled architecture
  final StudentRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StudentProfileController(this._repository);

  // Reactive UI State
  final RxBool isLoading = false.obs;

  // Text Controllers for the View
  final TextEditingController nameController = TextEditingController();
  final TextEditingController programmeController = TextEditingController();
  final TextEditingController graduationYearController =
      TextEditingController();
  final TextEditingController cgpaController = TextEditingController();
  final TextEditingController activeBacklogsController =
      TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  @override
  void onClose() {
    // Always dispose controllers to prevent memory leaks
    nameController.dispose();
    programmeController.dispose();
    graduationYearController.dispose();
    cgpaController.dispose();
    activeBacklogsController.dispose();
    skillsController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Authentication required to save profile.');
      return;
    }

    try {
      isLoading.value = true;

      // 1. Data Conversion: Safely parse text inputs to numbers
      final int gradYear =
          int.tryParse(graduationYearController.text.trim()) ?? 0;
      final double cgpa = double.tryParse(cgpaController.text.trim()) ?? 0.0;
      final int backlogs =
          int.tryParse(activeBacklogsController.text.trim()) ?? 0;

      // 2. Parse skills from a comma-separated string into a clean List
      final List<String> skillsList = skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // 3. Construct the strict Domain Model
      final student = StudentModel(
        uid: user.uid,
        name: nameController.text.trim(),
        email: user.email ?? '', // Automatically fetch email from Auth
        programme: programmeController.text.trim(),
        graduationYear: gradYear,
        cgpa: cgpa,
        activeBacklogs: backlogs,
        skills: skillsList,
      );

      // 4. Pass to the abstracted Repository
      await _repository.saveStudentProfile(student);

      Get.snackbar(
        'Success',
        'Student profile updated successfully!',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      Get.offAll(() => StudentDashboard());
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

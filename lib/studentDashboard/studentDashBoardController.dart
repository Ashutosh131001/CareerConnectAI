import 'package:careerconnect/auth/SignIn.dart';
import 'package:careerconnect/myApplications/studentApplicationScreen.dart';
import 'package:careerconnect/profile/profileveiw.dart';
import 'package:careerconnect/studentDrive/studentDriveScreen.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentDashboardController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void navigateToDrives() {
    Get.to(() => StudentDrivesScreen());
    Get.snackbar(
      'Navigating',
      'Opening Available Placement Drives...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Get.toNamed('/student/drives');
  }

  void navigateToApplications() {
    Get.to(() => StudentApplicationsScreen());
    Get.snackbar(
      'Navigating',
      'Opening My Applications...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Get.toNamed('/student/applications');
  }

  void navigateToAIChat() {
    Get.to(ProfileScreen());
    Get.snackbar(
      'Navigating',
      'Launching CareerConnect AI Assistant...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Get.toNamed('/student/chat');
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(SignInScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out safely.');
    }
  }
}

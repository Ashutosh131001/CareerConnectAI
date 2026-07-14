import 'package:careerconnect/adminApplication/adminApplicationScreen.dart';
import 'package:careerconnect/auth/SignIn.dart';
import 'package:careerconnect/company/comapnyVeiw.dart';
import 'package:careerconnect/placementDrive/driveveiw.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboardController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // We can use this later to show total companies/drives on the dashboard
  final RxBool isLoadingStats = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchDashboardStats();
  }

  void _fetchDashboardStats() {
    // Placeholder for future logic where we fetch total applications, etc.
    isLoadingStats.value = true;
    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      isLoadingStats.value = false;
    });
  }

  void navigateToCompanyManagement() {
    Get.to(() => AddCompanyScreen());
    Get.snackbar(
      'Navigating',
      'Opening Company Management...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Get.toNamed('/admin/companies');
  }

  void navigateToDriveManagement() {
    Get.to(() => CreateDriveScreen());
    Get.snackbar(
      'Navigating',
      'Opening Placement Drives...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Get.toNamed('/admin/drives');
  }

  void navigateToApplications() {
    Get.to(() => AdminApplicationsScreen());
    Get.snackbar(
      'Navigating',
      'Opening Application Review...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Get.toNamed('/admin/applications');
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(SignInScreen()); // Assuming you have a route set up for login
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out safely.');
    }
  }
}

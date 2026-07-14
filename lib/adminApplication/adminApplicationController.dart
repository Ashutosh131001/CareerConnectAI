import 'package:careerconnect/application/applicationModel.dart';
import 'package:careerconnect/application/applicationRepo.dart';
import 'package:get/get.dart';


class AdminApplicationsController extends GetxController {
  final ApplicationRepository _appRepo;

  AdminApplicationsController(this._appRepo);

  final RxList<ApplicationModel> allApplications = <ApplicationModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllApplications();
  }

  Future<void> fetchAllApplications() async {
    try {
      isLoading.value = true;
      final apps = await _appRepo.getAllApplications();
      allApplications.assignAll(apps);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load applications.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(ApplicationModel application, String newStatus) async {
    // Prevent unnecessary database writes if the status is the same
    if (application.status == newStatus) return;

    try {
      await _appRepo.updateApplicationStatus(application.id, newStatus);
      
      // Update the local state so the UI refreshes instantly without another database read
      final index = allApplications.indexWhere((app) => app.id == application.id);
      if (index != -1) {
        // Create a new model with the updated status
        final updatedApp = ApplicationModel(
          id: application.id,
          studentId: application.studentId,
          driveId: application.driveId,
          companyName: application.companyName,
          jobRole: application.jobRole,
          status: newStatus,
          appliedAt: application.appliedAt,
        );
        allApplications[index] = updatedApp;
      }
      
      Get.snackbar(
        'Status Updated', 
        'Application marked as $newStatus',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status.');
    }
  }
}
import 'package:careerconnect/application/driveDetailScreen.dart';
import 'package:careerconnect/placementDrive/placementDriveRepo.dart';
import 'package:careerconnect/placementDrive/placementdriveModel.dart';
import 'package:get/get.dart';

class StudentDrivesController extends GetxController {
  final DriveRepository _driveRepo;

  StudentDrivesController(this._driveRepo);

  final RxList<PlacementDriveModel> availableDrives =
      <PlacementDriveModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDrives();
  }

  Future<void> fetchDrives() async {
    try {
      isLoading.value = true;
      // Fetch all drives from the repository you built earlier
      final drives = await _driveRepo.getAllDrives();

      // Filter out drives where the deadline has already passed
      final activeDrives = drives
          .where((d) => d.deadline.isAfter(DateTime.now()))
          .toList();

      availableDrives.assignAll(activeDrives);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load placement drives.');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDriveDetails(PlacementDriveModel drive) {
    Get.to(() => DriveDetailScreen(drive: drive));
    Get.snackbar(
      'Navigating',
      'Opening details for ${drive.companyName}...',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: We will build the Drive Detail & Apply Screen next!
    // Get.to(() => DriveDetailScreen(drive: drive));
  }
}

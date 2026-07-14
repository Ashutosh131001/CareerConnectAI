import 'package:careerconnect/application/applicationModel.dart';
import 'package:careerconnect/application/applicationRepo.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentApplicationsController extends GetxController {
  final ApplicationRepository _appRepo;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StudentApplicationsController(this._appRepo);

  final RxList<ApplicationModel> myApplications = <ApplicationModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyApplications();
  }

  Future<void> fetchMyApplications() async {
    final studentId = _auth.currentUser?.uid;
    if (studentId == null) {
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final apps = await _appRepo.getApplicationsForStudent(studentId);
      myApplications.assignAll(apps);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load your applications.');
    } finally {
      isLoading.value = false;
    }
  }
}
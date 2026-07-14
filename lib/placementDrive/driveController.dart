import 'package:careerconnect/company/comapnyRepo.dart';
import 'package:careerconnect/company/companyModel.dart';
import 'package:careerconnect/placementDrive/placementDriveRepo.dart';
import 'package:careerconnect/placementDrive/placementdriveModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CreateDriveController extends GetxController {
  final DriveRepository _driveRepo;
  final CompanyRepository _companyRepo;

  CreateDriveController(this._driveRepo, this._companyRepo);

  final RxBool isLoading = false.obs;
  final RxBool isFetchingCompanies = true.obs;
  
  // State for Dropdown and DatePicker
  final RxList<CompanyModel> companies = <CompanyModel>[].obs;
  final Rx<CompanyModel?> selectedCompany = Rx<CompanyModel?>(null);
  final Rx<DateTime?> selectedDeadline = Rx<DateTime?>(null);

  // UI Text Controllers
  final TextEditingController jobRoleController = TextEditingController();
  final TextEditingController ctcController = TextEditingController();
  final TextEditingController minCgpaController = TextEditingController();
  final TextEditingController maxBacklogsController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    try {
      isFetchingCompanies.value = true;
      final fetchedCompanies = await _companyRepo.getAllCompanies();
      companies.assignAll(fetchedCompanies);
    } catch (e) {
      Get.snackbar('Error', 'Could not load companies for dropdown.');
    } finally {
      isFetchingCompanies.value = false;
    }
  }

  Future<void> pickDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F172A), // Slate 900
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDeadline.value = picked;
    }
  }

  Future<void> saveDrive() async {
    if (selectedCompany.value == null) {
      Get.snackbar('Validation', 'Please select a company.');
      return;
    }
    if (selectedDeadline.value == null) {
      Get.snackbar('Validation', 'Please select a deadline.');
      return;
    }

    try {
      isLoading.value = true;

      // Parse string inputs to actual numbers safely
      final double ctc = double.tryParse(ctcController.text.trim()) ?? 0.0;
      final double minCgpa = double.tryParse(minCgpaController.text.trim()) ?? 0.0;
      final int maxBacklogs = int.tryParse(maxBacklogsController.text.trim()) ?? 0;
      
      // Convert comma-separated string to list
      final List<String> skillsList = skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // 1. Build the Encapsulated Model
      final drive = PlacementDriveModel(
        id: '', 
        companyId: selectedCompany.value!.id,
        companyName: selectedCompany.value!.name,
        jobRole: jobRoleController.text.trim(),
        ctc: ctc,
        deadline: selectedDeadline.value!,
        minCgpa: minCgpa,
        maxActiveBacklogs: maxBacklogs,
        requiredSkills: skillsList,
      );

      // 2. Pass to the Repository
      await _driveRepo.saveDrive(drive);

      _clearFields();
      Get.snackbar(
        'Success', 
        'Placement drive created successfully!',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      Get.snackbar('Error', 'Failed to save drive: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFields() {
    jobRoleController.clear();
    ctcController.clear();
    minCgpaController.clear();
    maxBacklogsController.clear();
    skillsController.clear();
    selectedCompany.value = null;
    selectedDeadline.value = null;
  }

  @override
  void onClose() {
    jobRoleController.dispose();
    ctcController.dispose();
    minCgpaController.dispose();
    maxBacklogsController.dispose();
    skillsController.dispose();
    super.onClose();
  }
}
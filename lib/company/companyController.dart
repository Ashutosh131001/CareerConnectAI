import 'package:careerconnect/company/comapnyRepo.dart';
import 'package:careerconnect/company/companyModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CompanyController extends GetxController {
  final CompanyRepository _repository;

  CompanyController(this._repository);

  final RxBool isLoading = false.obs;

  // UI Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sectorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    sectorController.dispose();
    descriptionController.dispose();
    websiteController.dispose();
    super.onClose();
  }

  Future<void> saveCompany() async {
    try {
      isLoading.value = true;

      // 1. Build the Encapsulated Model
      // We pass an empty ID because Firebase will automatically generate one for a new company
      final company = CompanyModel(
        id: '', 
        name: nameController.text.trim(),
        sector: sectorController.text.trim(),
        description: descriptionController.text.trim(),
        website: websiteController.text.trim(),
      );

      // 2. Pass to the Repository
      await _repository.saveCompany(company);

      // 3. Clear the form and show success
      _clearFields();
      Get.snackbar(
        'Success', 
        '${company.name} added to the system successfully!',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Optionally, navigate back to the dashboard
      // Get.back();

    } catch (e) {
      Get.snackbar('Error', 'Failed to save company: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFields() {
    nameController.clear();
    sectorController.clear();
    descriptionController.clear();
    websiteController.clear();
  }
}
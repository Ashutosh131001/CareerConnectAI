import 'package:careerconnect/company/comapnyRepo.dart';
import 'package:careerconnect/company/companyController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCompanyScreen extends StatelessWidget {
  AddCompanyScreen({super.key});

  // Inject the Controller and Repository
  final CompanyController controller = Get.put(
    CompanyController(FirebaseCompanyRepository()),
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        title: const Text(
          'Add New Company',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recruiter Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the details of the visiting company to prepare for placement drives.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 32),

                _PremiumInputField(
                  controller: controller.nameController,
                  label: 'Company Name',
                  hint: 'e.g. Google, TCS, Microsoft',
                  icon: Icons.business_rounded,
                  validator: (value) => value!.trim().isEmpty ? 'Company name is required' : null,
                ),
                const SizedBox(height: 16),

                _PremiumInputField(
                  controller: controller.sectorController,
                  label: 'Industry Sector',
                  hint: 'e.g. FinTech, E-Commerce, IT Services',
                  icon: Icons.category_rounded,
                  validator: (value) => value!.trim().isEmpty ? 'Sector is required' : null,
                ),
                const SizedBox(height: 16),

                _PremiumInputField(
                  controller: controller.websiteController,
                  label: 'Company Website',
                  hint: 'e.g. https://www.google.com',
                  icon: Icons.language_rounded,
                  keyboardType: TextInputType.url,
                  validator: (value) => value!.trim().isEmpty ? 'Website is required' : null,
                ),
                const SizedBox(height: 16),

                _PremiumInputField(
                  controller: controller.descriptionController,
                  label: 'Company Description',
                  hint: 'Brief overview of the company...',
                  icon: Icons.description_rounded,
                  maxLines: 4,
                  validator: (value) => value!.trim().isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 40),

                _SaveCompanyButton(
                  controller: controller,
                  formKey: _formKey,
                  primaryColor: primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS 
// -----------------------------------------------------------------

class _PremiumInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?) validator;

  const _PremiumInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF2563EB);
    const inputFillColor = Color(0xFFF8FAFC);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accentColor, width: 1.5),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 70.0 : 0),
          child: Icon(icon, color: Colors.grey.shade500),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
      validator: validator,
    );
  }
}

class _SaveCompanyButton extends StatelessWidget {
  final CompanyController controller;
  final GlobalKey<FormState> formKey;
  final Color primaryColor;

  const _SaveCompanyButton({
    required this.controller,
    required this.formKey,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  if (formKey.currentState!.validate()) {
                    controller.saveCompany();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: primaryColor.withOpacity(0.6),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Add Company',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
        ),
      ),
    );
  }
}
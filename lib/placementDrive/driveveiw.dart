import 'package:careerconnect/company/comapnyRepo.dart';
import 'package:careerconnect/company/companyModel.dart';
import 'package:careerconnect/placementDrive/driveController.dart';
import 'package:careerconnect/placementDrive/placementDriveRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateDriveScreen extends StatelessWidget {
  CreateDriveScreen({super.key});

  final CreateDriveController controller = Get.put(
    CreateDriveController(
      FirebaseDriveRepository(),
      FirebaseCompanyRepository(),
    ),
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
          'Create Placement Drive',
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
                const _SectionTitle(title: 'Job Details'),

                // Reactive Dropdown for Companies
                Obx(() {
                  if (controller.isFetchingCompanies.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.companies.isEmpty) {
                    return const Text(
                      'Please add a company first!',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return _CompanyDropdown(controller: controller);
                }),

                const SizedBox(height: 16),
                _PremiumInputField(
                  controller: controller.jobRoleController,
                  label: 'Job Role',
                  hint: 'e.g. Software Development Engineer',
                  icon: Icons.work_outline_rounded,
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Role is required' : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _PremiumInputField(
                        controller: controller.ctcController,
                        label: 'Package (LPA)',
                        hint: 'e.g. 12.5',
                        icon: Icons.attach_money_rounded,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) =>
                            value!.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _DatePickerField(controller: controller)),
                  ],
                ),

                const SizedBox(height: 32),
                const _SectionTitle(
                  title: 'Eligibility Criteria (Crucial for AI)',
                ),

                Row(
                  children: [
                    Expanded(
                      child: _PremiumInputField(
                        controller: controller.minCgpaController,
                        label: 'Min CGPA',
                        hint: 'e.g. 7.5',
                        icon: Icons.grade_outlined,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) =>
                            value!.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _PremiumInputField(
                        controller: controller.maxBacklogsController,
                        label: 'Max Backlogs',
                        hint: 'e.g. 0',
                        icon: Icons.warning_amber_rounded,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _PremiumInputField(
                  controller: controller.skillsController,
                  label: 'Required Skills (Comma separated)',
                  hint: 'e.g. Flutter, Firebase, Java',
                  icon: Icons.code_rounded,
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Add at least one skill' : null,
                ),

                const SizedBox(height: 48),
                _SaveDriveButton(
                  controller: controller,
                  formKey: _formKey,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 24),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2563EB),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _CompanyDropdown extends StatelessWidget {
  final CreateDriveController controller;

  const _CompanyDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    const inputFillColor = Color(0xFFF8FAFC);

    return DropdownButtonFormField<CompanyModel>(
      value: controller.selectedCompany.value,
      decoration: InputDecoration(
        labelText: 'Select Company',
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.business_rounded, color: Colors.grey.shade500),
      ),
      items: controller.companies.map((company) {
        return DropdownMenuItem(value: company, child: Text(company.name));
      }).toList(),
      onChanged: (value) => controller.selectedCompany.value = value,
      validator: (value) => value == null ? 'Please select a company' : null,
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final CreateDriveController controller;

  const _DatePickerField({required this.controller});

  @override
  Widget build(BuildContext context) {
    const inputFillColor = Color(0xFFF8FAFC);

    return InkWell(
      onTap: () => controller.pickDeadline(context),
      child: Obx(() {
        final date = controller.selectedDeadline.value;
        final dateStr = date == null
            ? 'Deadline'
            : DateFormat('dd MMM yyyy').format(date);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          decoration: BoxDecoration(
            color: inputFillColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: Colors.grey.shade500,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  dateStr,
                  style: TextStyle(
                    color: date == null ? Colors.grey.shade600 : Colors.black87,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _PremiumInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  const _PremiumInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF2563EB);
    const inputFillColor = Color(0xFFF8FAFC);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
      validator: validator,
    );
  }
}

class _SaveDriveButton extends StatelessWidget {
  final CreateDriveController controller;
  final GlobalKey<FormState> formKey;
  final Color primaryColor;

  const _SaveDriveButton({
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
                    controller.saveDrive();
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
                  'Publish Placement Drive',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }
}

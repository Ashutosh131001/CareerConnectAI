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
    const backgroundColor = Color(0xFFF8FAFC); // Premium slate background

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(context, primaryColor),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderBanner(),
                      const SizedBox(height: 32),

                      // Card 1: Drive Details
                      _FormSectionCard(
                        title: 'Drive Overview',
                        icon: Icons.work_outline_rounded,
                        children: [
                          Obx(() {
                            if (controller.isFetchingCompanies.value) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              );
                            }
                            if (controller.companies.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.red.shade100,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning_rounded,
                                      color: Colors.red.shade400,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Please register a company first.',
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return _CompanyDropdown(controller: controller);
                          }),
                          const SizedBox(height: 16),
                          _PremiumInputField(
                            controller: controller.jobRoleController,
                            label: 'Job Role',
                            hint: 'e.g. Software Development Engineer',
                            icon: Icons.badge_outlined,
                            validator: (value) => value!.trim().isEmpty
                                ? 'Role is required'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _PremiumInputField(
                                  controller: controller.ctcController,
                                  label: 'Package (LPA)',
                                  hint: 'e.g. 12.5',
                                  icon: Icons.payments_outlined,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator: (value) =>
                                      value!.trim().isEmpty ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _DatePickerField(controller: controller),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Card 2: Eligibility Requirements
                      _FormSectionCard(
                        title: 'Eligibility Criteria',
                        subtitle:
                            'Crucial parameters for AI filtering & student tracking',
                        icon: Icons.rule_rounded,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _PremiumInputField(
                                  controller: controller.minCgpaController,
                                  label: 'Min CGPA',
                                  hint: 'e.g. 7.5',
                                  icon: Icons.grade_outlined,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
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
                            label: 'Required Skills',
                            hint: 'e.g. Flutter, Node.js, Python...',
                            icon: Icons.auto_awesome_rounded,
                            validator: (value) => value!.trim().isEmpty
                                ? 'Add at least one skill'
                                : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                      _SaveDriveButton(
                        controller: controller,
                        formKey: _formKey,
                      ),
                      const SizedBox(height: 40), // Bottom padding buffer
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom modern header
  Widget _buildCustomHeader(BuildContext context, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              color: primaryColor,
              onPressed: () => Get.back(),
            ),
          ),
          const SizedBox(width: 20),
          Text(
            'New Drive',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: primaryColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Beautiful contextual banner
  Widget _buildHeaderBanner() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.campaign_rounded,
            color: Color(0xFF2563EB),
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configure Drive',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Setup a new placement opportunity and set eligibility algorithms.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _FormSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Widget> children;

  const _FormSectionCard({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _CompanyDropdown extends StatelessWidget {
  final CreateDriveController controller;

  const _CompanyDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF2563EB);
    const inputFillColor = Color(0xFFF8FAFC);

    return DropdownButtonFormField<CompanyModel>(
      value: controller.selectedCompany.value,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey.shade500,
      ),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        labelText: 'Select Company',
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        floatingLabelStyle: const TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1),
        ),
        prefixIcon: Icon(
          Icons.domain_rounded,
          color: Colors.grey.shade400,
          size: 22,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
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
    const accentColor = Color(0xFF2563EB);
    const inputFillColor = Color(0xFFF8FAFC);

    return InkWell(
      onTap: () => controller.pickDeadline(context),
      borderRadius: BorderRadius.circular(16),
      child: Obx(() {
        final date = controller.selectedDeadline.value;
        final dateStr = date == null
            ? ''
            : DateFormat('dd MMM yyyy').format(date);

        // We use an InputDecorator to ensure it looks 100% identical
        // to the adjacent _PremiumInputField in height, style, and padding.
        return InputDecorator(
          isEmpty: date == null,
          decoration: InputDecoration(
            labelText: 'Deadline',
            labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            floatingLabelStyle: const TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: inputFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(
              Icons.calendar_today_rounded,
              color: Colors.grey.shade400,
              size: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),
          ),
          child: Text(
            dateStr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F172A),
            ),
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
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        floatingLabelStyle: const TextStyle(
          color: accentColor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
      ),
      validator: validator,
    );
  }
}

class _SaveDriveButton extends StatelessWidget {
  final CreateDriveController controller;
  final GlobalKey<FormState> formKey;

  const _SaveDriveButton({required this.controller, required this.formKey});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2563EB);

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
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 10,
            shadowColor: primaryColor.withOpacity(0.4),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.rocket_launch_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Publish Placement Drive',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

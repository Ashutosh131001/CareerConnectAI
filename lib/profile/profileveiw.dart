import 'package:careerconnect/profile/profileveiwmodel.dart';
import 'package:careerconnect/student/studentRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../student/student_repository.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(
    ProfileController(FirebaseStudentRepository()),
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const accentColor = Color(0xFF2563EB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        title: const Text(
          'My Profile',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        return SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: accentColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _ProfileInputField(
                    controller: controller.nameController,
                    label: 'Full Name',
                    icon: Icons.badge_outlined,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _ProfileInputField(
                          controller: controller.programmeController,
                          label: 'Programme (e.g. B.Tech CS)',
                          icon: Icons.school_outlined,
                          validator: (value) =>
                              value!.trim().isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: _ProfileInputField(
                          controller: controller.graduationYearController,
                          label: 'Grad Year',
                          icon: Icons.calendar_today_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.trim().isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Academic Standing (Crucial for Eligibility)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _ProfileInputField(
                          controller: controller.cgpaController,
                          label: 'Current CGPA',
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
                        child: _ProfileInputField(
                          controller: controller.backlogsController,
                          label: 'Active Backlogs',
                          icon: Icons.warning_amber_rounded,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.trim().isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Professional Skills',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _ProfileInputField(
                    controller: controller.skillsController,
                    label: 'Skills (Comma separated)',
                    icon: Icons.code_rounded,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Add at least one skill' : null,
                  ),

                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSaving.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                controller.saveProfile();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isSaving.value
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// -----------------------------------------------------------------
// WIDGET
// -----------------------------------------------------------------

class _ProfileInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  const _ProfileInputField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    const inputFillColor = Color(0xFFF8FAFC);
    const accentColor = Color(0xFF2563EB);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
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

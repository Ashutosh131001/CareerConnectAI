import 'package:careerconnect/student/studentController.dart';
import 'package:careerconnect/student/studentRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentProfileScreen extends StatelessWidget {
  StudentProfileScreen({super.key});

  // Inject Controller and Repository here
  final StudentProfileController controller = Get.put(
    StudentProfileController(FirebaseStudentRepository()),
  );
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const _ProfileHeader(),
                      const SizedBox(height: 32),
                      
                      const _SectionTitle(title: 'Personal Details'),
                      _PremiumInputField(
                        controller: controller.nameController,
                        label: 'Full Name',
                        hint: 'e.g. Ashutosh',
                        icon: Icons.person_outline_rounded,
                        validator: (value) => value!.trim().isEmpty ? 'Name is required' : null,
                      ),
                      
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Academic Details'),
                      _PremiumInputField(
                        controller: controller.programmeController,
                        label: 'Programme',
                        hint: 'e.g. B.Tech Computer Science',
                        icon: Icons.school_outlined,
                        validator: (value) => value!.trim().isEmpty ? 'Programme is required' : null,
                      ),
                      const SizedBox(height: 16),
                      
                      // Using a Row for side-by-side numerical inputs
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _PremiumInputField(
                              controller: controller.graduationYearController,
                              label: 'Grad Year',
                              hint: 'e.g. 2028',
                              icon: Icons.calendar_today_rounded,
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.trim().length != 4 ? 'Invalid year' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _PremiumInputField(
                              controller: controller.cgpaController,
                              label: 'CGPA',
                              hint: 'e.g. 8.5',
                              icon: Icons.grade_outlined,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (value) => value!.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      _PremiumInputField(
                        controller: controller.activeBacklogsController,
                        label: 'Active Backlogs',
                        hint: '0 if none',
                        icon: Icons.warning_amber_rounded,
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.trim().isEmpty ? 'Required' : null,
                      ),
                      
                      const SizedBox(height: 24),
                      const _SectionTitle(title: 'Professional Skills'),
                      _PremiumInputField(
                        controller: controller.skillsController,
                        label: 'Skills (Comma Separated)',
                        hint: 'Java, Spring Boot, Flutter',
                        icon: Icons.code_rounded,
                        validator: (value) => value!.trim().isEmpty ? 'Please add at least one skill' : null,
                      ),
                      
                      const SizedBox(height: 48),
                      
                      _SaveProfileButton(
                        controller: controller,
                        formKey: _formKey,
                        primaryColor: primaryColor,
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS FOR CLEAN ARCHITECTURE & DEBUGGING
// -----------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const accentColor = Color(0xFF2563EB);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.school_rounded,
            color: accentColor,
            size: 36,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Student Profile',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set up your ITM placement profile to enable AI career guidance and drive eligibility checks.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2563EB), // accentColor
          letterSpacing: 0.5,
        ),
      ),
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
      textCapitalization: TextCapitalization.words,
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

class _SaveProfileButton extends StatelessWidget {
  final StudentProfileController controller;
  final GlobalKey<FormState> formKey;
  final Color primaryColor;

  const _SaveProfileButton({
    required this.controller,
    required this.formKey,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value
            ? null
            : () {
                if (formKey.currentState!.validate()) {
                  controller.saveProfile();
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
                'Save Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }
}
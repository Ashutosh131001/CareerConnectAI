import 'package:careerconnect/profile/profileveiwmodel.dart';
import 'package:careerconnect/student/studentRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(
    ProfileController(FirebaseStudentRepository()),
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2563EB),
                      strokeWidth: 3,
                    ),
                  );
                }

                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildProfileAvatar(),
                        const SizedBox(height: 32),

                        // Section 1: Personal Details
                        _ProfileSectionCard(
                          title: 'Personal Details',
                          icon: Icons.person_outline_rounded,
                          children: [
                            _PremiumInputField(
                              controller: controller.nameController,
                              label: 'Full Name',
                              icon: Icons.badge_outlined,
                              validator: (value) => value!.trim().isEmpty
                                  ? 'Name is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _PremiumInputField(
                                    controller: controller.programmeController,
                                    label: 'Programme',
                                    hint: 'e.g. B.Tech CS',
                                    icon: Icons.school_outlined,
                                    validator: (value) => value!.trim().isEmpty
                                        ? 'Required'
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 1,
                                  child: _PremiumInputField(
                                    controller:
                                        controller.graduationYearController,
                                    label: 'Grad Year',
                                    icon: Icons.calendar_today_rounded,
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.trim().isEmpty
                                        ? 'Required'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Section 2: Academic Standing
                        _ProfileSectionCard(
                          title: 'Academic Standing',
                          subtitle: 'Crucial for drive eligibility algorithms',
                          icon: Icons.analytics_outlined,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _PremiumInputField(
                                    controller: controller.cgpaController,
                                    label: 'Current CGPA',
                                    icon: Icons.grade_outlined,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: (value) => value!.trim().isEmpty
                                        ? 'Required'
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _PremiumInputField(
                                    controller: controller.backlogsController,
                                    label: 'Active Backlogs',
                                    icon: Icons.warning_amber_rounded,
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.trim().isEmpty
                                        ? 'Required'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Section 3: Professional Skills
                        _ProfileSectionCard(
                          title: 'Professional Skills',
                          icon: Icons.code_rounded,
                          children: [
                            _PremiumInputField(
                              controller: controller.skillsController,
                              label: 'Top Skills',
                              hint: 'Flutter, Python, UI/UX...',
                              icon: Icons.auto_awesome_rounded,
                              validator: (value) => value!.trim().isEmpty
                                  ? 'Add at least one skill'
                                  : null,
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Save Button
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
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 10,
                              shadowColor: primaryColor.withOpacity(0.4),
                            ),
                            child: controller.isSaving.value
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Save Profile',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 40), // Extra bottom padding
                      ],
                    ),
                  ),
                );
              }),
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
            'My Profile',
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

  Widget _buildProfileAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(4), // Ring thickness
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF1D4ED8),
              ], // Premium Blue Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundColor: const Color(0xFFF8FAFC),
              child: Icon(
                Icons.person_rounded,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A), // Primary Dark
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _ProfileSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Widget> children;

  const _ProfileSectionCard({
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

class _PremiumInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  const _PremiumInputField({
    required this.controller,
    required this.label,
    this.hint,
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
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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

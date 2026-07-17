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

                      // Card 1: Core Identity
                      _FormSectionCard(
                        title: 'Core Identity',
                        icon: Icons.business_center_rounded,
                        children: [
                          _PremiumInputField(
                            controller: controller.nameController,
                            label: 'Company Name',
                            hint: 'e.g. Google, TCS, Microsoft',
                            icon: Icons.domain_rounded,
                            validator: (value) => value!.trim().isEmpty
                                ? 'Company name is required'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _PremiumInputField(
                            controller: controller.sectorController,
                            label: 'Industry Sector',
                            hint: 'e.g. FinTech, E-Commerce, IT',
                            icon: Icons.category_rounded,
                            validator: (value) => value!.trim().isEmpty
                                ? 'Sector is required'
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Card 2: Digital Presence & Details
                      _FormSectionCard(
                        title: 'Digital & Details',
                        icon: Icons.language_rounded,
                        children: [
                          _PremiumInputField(
                            controller: controller.websiteController,
                            label: 'Company Website',
                            hint: 'e.g. https://www.google.com',
                            icon: Icons.link_rounded,
                            keyboardType: TextInputType.url,
                            validator: (value) => value!.trim().isEmpty
                                ? 'Website is required'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _PremiumInputField(
                            controller: controller.descriptionController,
                            label: 'Company Description',
                            hint:
                                'Brief overview of the company, work culture, and requirements...',
                            icon: Icons.description_rounded,
                            maxLines: 4,
                            validator: (value) => value!.trim().isEmpty
                                ? 'Description is required'
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      _SaveCompanyButton(
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
            'New Company',
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
            Icons.add_business_rounded,
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
                'Recruiter Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Register a new visiting company to prepare for upcoming placement drives.',
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
  final IconData icon;
  final List<Widget> children;

  const _FormSectionCard({
    required this.title,
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
              Icon(icon, color: const Color(0xFF0F172A), size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
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
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF0F172A),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
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
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            bottom: maxLines > 1 ? (24.0 * (maxLines - 1)) : 0,
          ),
          child: Icon(icon, color: Colors.grey.shade400, size: 22),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
      ),
      validator: validator,
    );
  }
}

class _SaveCompanyButton extends StatelessWidget {
  final CompanyController controller;
  final GlobalKey<FormState> formKey;

  const _SaveCompanyButton({required this.controller, required this.formKey});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(
      0xFF2563EB,
    ); // Changed to vibrant blue for action

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
                    Icon(Icons.domain_add_rounded, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Register Company',
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

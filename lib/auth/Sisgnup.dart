import 'package:careerconnect/auth/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const accentColor = Color(0xFF2563EB);
    const inputFillColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 1),

                        // Premium Header
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Back button for easy navigation
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1_rounded,
                                color: accentColor,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Join your campus network to get started.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(flex: 1),

                        // Input Fields
                        Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: inputFillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: accentColor,
                                    width: 1.5,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.mail_outline_rounded,
                                  color: Colors.grey.shade500,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter a valid email' : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: inputFillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: accentColor,
                                    width: 1.5,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: Colors.grey.shade500,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: inputFillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: accentColor,
                                    width: 1.5,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_reset_rounded,
                                  color: Colors.grey.shade500,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Action Button
                        Obx(
                          () => ElevatedButton(
                            onPressed: authController.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      authController.register(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: primaryColor.withOpacity(
                                0.6,
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: authController.isLoading.value
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // Bottom Navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

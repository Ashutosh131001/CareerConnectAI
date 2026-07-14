import 'package:careerconnect/auth/Sisgnup.dart'; // Double check this file name spelling!
import 'package:careerconnect/auth/authController.dart';
import 'package:careerconnect/auth/authRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  // Safely inject or find the AuthController
  final AuthController authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController(FirebaseAuthRepository()));

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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

                        // Header
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.bubble_chart_rounded,
                                color: accentColor,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to seamlessly connect with your network.',
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
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter a valid email address'
                                  : null,
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
                                  Icons.local_activity_rounded,
                                  color: Colors.grey.shade500,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                              ),
                              obscureText: true,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your password'
                                  : null,
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
                                      authController.login(
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
                                    'Sign In',
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
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => SignUpScreen()),
                              child: const Text(
                                'Sign Up',
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
            ); // <-- This was the syntax error. Changed from `];` to `);`
          },
        ),
      ),
    );
  }
}

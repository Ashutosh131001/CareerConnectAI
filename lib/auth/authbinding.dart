// lib/core/bindings/auth_binding.dart

import 'package:careerconnect/auth/authController.dart';
import 'package:careerconnect/auth/authRepo.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Inject the concrete implementation into the controller
    Get.put<AuthController>(
      AuthController(FirebaseAuthRepository()),
      permanent: true,
    );
  }
}

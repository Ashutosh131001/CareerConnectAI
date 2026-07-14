import 'package:careerconnect/auth/authController.dart';
import 'package:careerconnect/auth/authRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:careerconnect/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 1. Inject the Auth dependencies immediately
  Get.put<AuthRepository>(FirebaseAuthRepository());
  Get.put<AuthController>(AuthController(Get.find<AuthRepository>()));

  runApp(const CareerConnectApp());
}

class CareerConnectApp extends StatelessWidget {
  const CareerConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Career Connect AI',
      debugShowCheckedModeBanner: false,

      // Initial state: A simple loading spinner.
      // AuthController will instantly replace this using direct navigation.
      home: const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0F172A)),
        ),
      ),
    );
  }
}

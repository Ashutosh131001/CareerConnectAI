import 'package:careerconnect/adminDashboard/admindash.dart';
import 'package:careerconnect/auth/SignIn.dart';
import 'package:careerconnect/auth/authRepo.dart';
import 'package:careerconnect/student/studentVeiw.dart';
import 'package:careerconnect/studentDashboard/studentDashBoardVeiw.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;

  AuthController(this._repository);

  // This variable holds the current Firebase user
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    // Bind the stream to our variable. Every time auth state changes,
    // it will trigger the _handleAuthRouting method.
    firebaseUser.bindStream(_repository.authStateChanges);
    ever(firebaseUser, _handleAuthRouting);
  }

  // THIS IS THE BRAIN OF YOUR APP ROUTING
  Future<void> _handleAuthRouting(User? user) async {
    if (user == null) {
      // Not logged in -> Send to Login Screen
      Get.offAll(() => SignInScreen());
      return;
    }

    // User is logged in! Let's find out who they are.
    try {
      final userData = await _repository.getUserFirestoreData(user.uid);

      if (userData == null) {
        Get.offAll(() => StudentProfileScreen());
      } else {
        final String role = userData['role'] ?? 'student';

        if (role == 'admin') {
          Get.offAll(() => AdminDashboard());
        } else {
          Get.offAll(() => StudentDashboard());
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to retrieve user data.');
    }
  }

  // --- Auth Actions for your UI to call ---

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _repository.signInWithEmail(email, password);
      // We don't need to manually route here!
      // The `ever` listener above will detect the sign-in and auto-route.
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      isLoading.value = true;
      await _repository.registerWithEmail(email, password);
      Get.offAll(StudentProfileScreen());
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

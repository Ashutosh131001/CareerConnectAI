import 'package:careerconnect/application/applicationModel.dart';
import 'package:careerconnect/application/applicationRepo.dart';
import 'package:careerconnect/chatbot/chatScreen.dart';
import 'package:careerconnect/myApplications/studentApplicationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StudentApplicationsScreen extends StatelessWidget {
  StudentApplicationsScreen({super.key});

  final StudentApplicationsController controller = Get.put(
    StudentApplicationsController(FirebaseApplicationRepository()),
  );

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const backgroundColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        title: const Text(
          'My Applications',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (controller.myApplications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_open_rounded,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'You haven\'t applied to any drives yet.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchMyApplications,
          color: primaryColor,
          child: ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: controller.myApplications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final app = controller.myApplications[index];
              return _ApplicationCard(application: app);
            },
          ),
        );
      }),
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  const _ApplicationCard({required this.application});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return InkWell(
      onTap: () {
        Get.to(() => AiChatScreen(application: application));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.jobRole,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        application.companyName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: application.status),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 6),
                Text(
                  'Applied: ${dateFormat.format(application.appliedAt)}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    // Determine colors based on status
    switch (status.toLowerCase()) {
      case 'selected':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'interview':
      case 'interview scheduled':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        break;
      case 'rejected':
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        break;
      case 'pending':
      default:
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

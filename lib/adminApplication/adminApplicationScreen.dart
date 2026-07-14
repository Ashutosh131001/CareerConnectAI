import 'package:careerconnect/adminApplication/adminApplicationController.dart';
import 'package:careerconnect/application/applicationModel.dart';
import 'package:careerconnect/application/applicationRepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';



class AdminApplicationsScreen extends StatelessWidget {
  AdminApplicationsScreen({super.key});

  final AdminApplicationsController controller = Get.put(
    AdminApplicationsController(FirebaseApplicationRepository()),
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
          'Review Applications',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }

        if (controller.allApplications.isEmpty) {
          return Center(
            child: Text(
              'No applications received yet.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAllApplications,
          color: primaryColor,
          child: ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: controller.allApplications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final app = controller.allApplications[index];
              return _AdminAppCard(
                application: app,
                onStatusChanged: (newStatus) {
                  if (newStatus != null) {
                    controller.updateStatus(app, newStatus);
                  }
                },
              );
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

class _AdminAppCard extends StatelessWidget {
  final ApplicationModel application;
  final ValueChanged<String?> onStatusChanged;

  const _AdminAppCard({
    required this.application,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    
    // The allowed statuses
    final statuses = ['Pending', 'Interview', 'Selected', 'Rejected'];

    return Container(
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      application.companyName,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Student ID: ${application.studentId.substring(0, 8)}...',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              // Status Dropdown
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: application.status,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    items: statuses.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: onStatusChanged,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Icon(Icons.history_rounded, size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                'Applied: ${dateFormat.format(application.appliedAt)}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
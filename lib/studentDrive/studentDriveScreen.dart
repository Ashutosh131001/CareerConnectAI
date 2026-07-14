import 'package:careerconnect/placementDrive/placementDriveRepo.dart';
import 'package:careerconnect/placementDrive/placementdriveModel.dart';
import 'package:careerconnect/studentDrive/studentDriveController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StudentDrivesScreen extends StatelessWidget {
  StudentDrivesScreen({super.key});

  // Inject Controller and Repository
  final StudentDrivesController controller = Get.put(
    StudentDrivesController(FirebaseDriveRepository()),
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
          'Available Drives',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }

        if (controller.availableDrives.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No active drives right now.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchDrives,
          color: primaryColor,
          child: ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: controller.availableDrives.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final drive = controller.availableDrives[index];
              return _DriveCard(
                drive: drive,
                onTap: () => controller.navigateToDriveDetails(drive),
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

class _DriveCard extends StatelessWidget {
  final PlacementDriveModel drive;
  final VoidCallback onTap;

  const _DriveCard({required this.drive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business_center_rounded, color: Color(0xFF2563EB)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drive.jobRole,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        drive.companyName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoChip(
                  icon: Icons.attach_money_rounded, 
                  label: '${drive.ctc} LPA',
                ),
                _InfoChip(
                  icon: Icons.timer_outlined, 
                  label: 'Ends: ${dateFormat.format(drive.deadline)}',
                  isWarning: drive.deadline.difference(DateTime.now()).inDays <= 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isWarning;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isWarning ? Colors.red.shade700 : Colors.grey.shade700;
    
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
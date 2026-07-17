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
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(context, primaryColor),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2563EB), // Premium Blue
                      strokeWidth: 3,
                    ),
                  );
                }

                if (controller.availableDrives.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchDrives,
                  color: const Color(0xFF2563EB),
                  backgroundColor: Colors.white,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 16.0,
                      bottom: 40.0,
                    ),
                    itemCount: controller.availableDrives.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final drive = controller.availableDrives[index];
                      return _PremiumDriveCard(
                        drive: drive,
                        onTap: () => controller.navigateToDriveDetails(drive),
                      );
                    },
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
            'Available Drives',
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

  // Polished empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.work_off_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Active Drives',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new opportunities.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _PremiumDriveCard extends StatelessWidget {
  final PlacementDriveModel drive;
  final VoidCallback onTap;

  const _PremiumDriveCard({required this.drive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final daysLeft = drive.deadline.difference(DateTime.now()).inDays;
    final isUrgent = daysLeft <= 3 && daysLeft >= 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          highlightColor: const Color(0xFF2563EB).withOpacity(0.05),
          splashColor: const Color(0xFF2563EB).withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Premium Gradient Icon Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3B82F6),
                            Color(0xFF1D4ED8),
                          ], // Soft to Deep Blue
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.domain_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title and Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drive.jobRole,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            drive.companyName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Trailing Arrow
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey.shade400,
                        size: 14,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(height: 1, color: Colors.grey.shade100),
                const SizedBox(height: 16),

                // Tags Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PillChip(
                      icon: Icons.payments_rounded,
                      label: '${drive.ctc} LPA',
                      color: const Color(0xFF059669), // Emerald Green
                    ),
                    _PillChip(
                      icon: Icons.access_time_filled_rounded,
                      label: daysLeft < 0
                          ? 'Closed'
                          : 'Ends: ${dateFormat.format(drive.deadline)}',
                      color: isUrgent
                          ? const Color(0xFFDC2626)
                          : const Color(
                              0xFF64748B,
                            ), // Red if urgent, Slate otherwise
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _PillChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20), // Pill shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

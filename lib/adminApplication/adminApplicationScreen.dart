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
    const backgroundColor = Color(0xFFF8FAFC); // Premium slate background

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
                      color: Color(0xFFF59E0B), // Admin Amber
                      strokeWidth: 3,
                    ),
                  );
                }

                if (controller.allApplications.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchAllApplications,
                  color: const Color(0xFFF59E0B),
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
                    itemCount: controller.allApplications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final app = controller.allApplications[index];
                      return _PremiumAdminAppCard(
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
            'Review Applications',
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
              Icons.people_alt_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Applications Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Student submissions will appear here.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _PremiumAdminAppCard extends StatelessWidget {
  final ApplicationModel application;
  final ValueChanged<String?> onStatusChanged;

  const _PremiumAdminAppCard({
    required this.application,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Amber Gradient Icon Box (Matches Admin Dashboard)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD97706).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.assignment_ind_rounded, 
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
                      application.jobRole,
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
                      application.companyName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Student ID Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fingerprint_rounded, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            'ID: ${application.studentId.substring(0, 8).toUpperCase()}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 16),
          
          // Bottom Row (Date + Status Dropdown)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 14,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dateFormat.format(application.appliedAt),
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              // Dynamic Status Dropdown Pill
              _DynamicStatusDropdown(
                currentStatus: application.status,
                onChanged: onStatusChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DynamicStatusDropdown extends StatelessWidget {
  final String currentStatus;
  final ValueChanged<String?> onChanged;

  const _DynamicStatusDropdown({
    required this.currentStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Map status to specific premium colors
    Color baseColor;
    switch (currentStatus.toLowerCase()) {
      case 'selected':
        baseColor = const Color(0xFF059669); // Emerald
        break;
      case 'interview':
      case 'interview scheduled':
        baseColor = const Color(0xFF2563EB); // Blue
        break;
      case 'rejected':
        baseColor = const Color(0xFFDC2626); // Red
        break;
      case 'pending':
      default:
        baseColor = const Color(0xFFD97706); // Amber
        break;
    }

    final statuses = ['Pending', 'Interview', 'Selected', 'Rejected'];

    // If the current status is some edge case not in the list, fallback gracefully
    final displayStatus = statuses.contains(currentStatus) ? currentStatus : 'Pending';

    return Container(
      height: 32,
      padding: const EdgeInsets.only(left: 12, right: 8),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20), // Pill Shape
        border: Border.all(color: baseColor.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: displayStatus,
          icon: Icon(Icons.expand_more_rounded, color: baseColor, size: 18),
          elevation: 4,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          style: TextStyle(
            fontSize: 11, 
            fontWeight: FontWeight.w800, 
            color: baseColor,
            letterSpacing: 0.5,
          ),
          items: statuses.map((String status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status.toUpperCase()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
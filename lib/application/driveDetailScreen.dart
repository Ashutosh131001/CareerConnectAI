import 'package:careerconnect/application/applicationRepo.dart';
import 'package:careerconnect/application/driveDeatilController.dart';
import 'package:careerconnect/placementDrive/placementdriveModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DriveDetailScreen extends StatelessWidget {
  final PlacementDriveModel drive;

  DriveDetailScreen({super.key, required this.drive});

  @override
  Widget build(BuildContext context) {
    // We inject the controller here, passing the specific drive and repository
    final DriveDetailController controller = Get.put(
      DriveDetailController(FirebaseApplicationRepository(), drive),
      tag: drive.id, // Important: Use tag in case multiple detail screens open
    );

    const primaryColor = Color(0xFF0F172A);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        title: const Text('Drive Details', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                drive.jobRole,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                drive.companyName,
                style: const TextStyle(fontSize: 18, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),

              // Highlights Row
              Row(
                children: [
                  Expanded(child: _HighlightCard(icon: Icons.attach_money, label: 'Package', value: '${drive.ctc} LPA')),
                  const SizedBox(width: 16),
                  Expanded(child: _HighlightCard(icon: Icons.calendar_today, label: 'Deadline', value: dateFormat.format(drive.deadline))),
                ],
              ),
              const SizedBox(height: 32),

              // Eligibility Section
              const Text(
                'Eligibility Criteria',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 16),
              _EligibilityRow(label: 'Minimum CGPA', value: '${drive.minCgpa}'),
              const Divider(height: 24),
              _EligibilityRow(label: 'Max Active Backlogs', value: '${drive.maxActiveBacklogs}'),
              const Divider(height: 24),
              
              const Text('Required Skills:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: drive.requiredSkills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: const Color(0xFF2563EB).withOpacity(0.1),
                    labelStyle: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w500),
                    side: BorderSide.none,
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),

              // Apply Button bound to Controller
              Obx(() {
                if (controller.isCheckingStatus.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final bool alreadyApplied = controller.hasApplied.value;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: alreadyApplied || controller.isLoading.value 
                        ? null 
                        : () => controller.applyForDrive(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: alreadyApplied ? Colors.grey.shade400 : const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : Text(
                            alreadyApplied ? 'Already Applied' : 'Apply Now',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HighlightCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 24),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}

class _EligibilityRow extends StatelessWidget {
  final String label;
  final String value;

  const _EligibilityRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 15)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
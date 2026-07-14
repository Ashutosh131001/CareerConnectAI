import 'package:careerconnect/adminDashboard/adminDashBoardController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  // Inject the ViewModel
  final AdminDashboardController controller = Get.put(
    AdminDashboardController(),
  );

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0F172A);
    const backgroundColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(primaryColor),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _WelcomeHeader(),
              const SizedBox(height: 32),

              const Text(
                'Dashboard Controls',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),

              // 1. Company Management
              _AdminActionCard(
                title: 'Manage Companies',
                subtitle: 'Add or update visiting recruiters',
                icon: Icons.business_rounded,
                iconColor: const Color(0xFF2563EB),
                onTap: controller
                    .navigateToCompanyManagement, // Bound to Controller
              ),
              const SizedBox(height: 16),

              // 2. Placement Drive Management
              _AdminActionCard(
                title: 'Placement Drives',
                subtitle: 'Create drives and configure eligibility rules',
                icon: Icons.work_outline_rounded,
                iconColor: const Color(0xFF10B981),
                onTap:
                    controller.navigateToDriveManagement, // Bound to Controller
              ),
              const SizedBox(height: 16),

              // 3. Application Review
              _AdminActionCard(
                title: 'Review Applications',
                subtitle: 'Track student submissions and update status',
                icon: Icons.people_alt_outlined,
                iconColor: const Color(0xFFF59E0B),
                onTap: controller.navigateToApplications, // Bound to Controller
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color primaryColor) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Icon(
            Icons.admin_panel_settings_rounded,
            color: primaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'Placement Admin',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          onPressed: controller.logout, // Bound to Controller
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Coordinator Access',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome Back,',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Manage ITM Placements',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

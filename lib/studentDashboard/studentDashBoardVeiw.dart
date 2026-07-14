import 'package:careerconnect/studentDashboard/studentDashBoardController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDashboard extends StatelessWidget {
  StudentDashboard({super.key});

  // Inject the ViewModel
  final StudentDashboardController controller = Get.put(
    StudentDashboardController(),
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
              const _StudentWelcomeHeader(),
              const SizedBox(height: 32),

              const Text(
                'My Career Hub',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),

              // 1. Browse Drives
              _StudentActionCard(
                title: 'Placement Drives',
                subtitle: 'Browse companies and check your eligibility',
                icon: Icons.work_outline_rounded,
                iconColor: const Color(0xFF2563EB), // Blue
                onTap: controller.navigateToDrives,
              ),
              const SizedBox(height: 16),

              // 2. Track Applications
              _StudentActionCard(
                title: 'My Applications',
                subtitle: 'Track status and review past submissions',
                icon: Icons.track_changes_rounded,
                iconColor: const Color(0xFF10B981), // Green
                onTap: controller.navigateToApplications,
              ),
              const SizedBox(height: 16),

              // 3. AI Career Assistant
              _StudentActionCard(
                title: 'AI Career Assistant',
                subtitle: 'Get interview prep and eligibility explanations',
                icon: Icons.auto_awesome_rounded,
                iconColor: const Color(0xFF8B5CF6), // Purple
                onTap: controller.navigateToAIChat,
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
          Icon(Icons.school_rounded, color: primaryColor, size: 28),
          const SizedBox(width: 12),
          Text(
            'CareerConnect',
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
          onPressed: controller.logout,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _StudentWelcomeHeader extends StatelessWidget {
  const _StudentWelcomeHeader();

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
              'Student Portal',
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
            'Ready for your next step?',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Find Your Dream Role',
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

class _StudentActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _StudentActionCard({
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

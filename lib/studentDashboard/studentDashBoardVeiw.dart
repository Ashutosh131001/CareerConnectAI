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
    const backgroundColor = Color(
      0xFFF8FAFC,
    ); // Very light, premium slate background

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Premium scroll feel
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomHeader(primaryColor),
                const SizedBox(height: 32),

                const _StudentWelcomeBanner(),
                const SizedBox(height: 40),

                const Text(
                  'Explore Opportunities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),

                // 1. Browse Drives
                _PremiumActionCard(
                  title: 'Placement Drives',
                  subtitle: 'Browse companies & check eligibility',
                  icon: Icons.work_outline_rounded,
                  gradientColors: const [
                    Color(0xFF2563EB),
                    Color(0xFF3B82F6),
                  ], // Premium Blue Gradient
                  onTap: controller.navigateToDrives,
                ),
                const SizedBox(height: 16),

                // 2. Track Applications
                _PremiumActionCard(
                  title: 'My Applications',
                  subtitle: 'Track status and past submissions',
                  icon: Icons.track_changes_rounded,
                  gradientColors: const [
                    Color(0xFF059669),
                    Color(0xFF10B981),
                  ], // Premium Emerald Gradient
                  onTap: controller.navigateToApplications,
                ),
                const SizedBox(height: 16),

                // 3. AI Career Assistant
                _PremiumActionCard(
                  title: 'AI Career Assistant',
                  subtitle: 'Interview prep & smart guidance',
                  icon: Icons.auto_awesome_rounded,
                  gradientColors: const [
                    Color(0xFF7C3AED),
                    Color(0xFF8B5CF6),
                  ], // Premium Violet Gradient
                  isSparkle: true,
                  onTap: controller.navigateToAIChat,
                ),

                const SizedBox(height: 40), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Replaces the standard AppBar with a modern, personalized top row
  Widget _buildCustomHeader(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: const DecorationImage(
                  // You can replace this with NetworkImage for a real user avatar
                  image: AssetImage('assets/default_avatar.png'),
                  fit: BoxFit.cover,
                ),
              ),
              // Fallback icon if no image is provided
              child: const Icon(
                Icons.person_outline_rounded,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Future Leader', // Replace with user's name if available
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
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
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.redAccent,
              size: 22,
            ),
            onPressed: controller.logout,
            tooltip: 'Logout',
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _StudentWelcomeBanner extends StatelessWidget {
  const _StudentWelcomeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F172A),
            Color(0xFF334155),
          ], // Deep slate to lighter slate
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Decorative background circle 1
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Decorative background circle 2
            Positioned(
              right: 60,
              bottom: -60,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.rocket_launch_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'STUDENT PORTAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ready for your\nnext step?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find Your Dream Role',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final bool isSparkle;

  const _PremiumActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    this.isSparkle = false,
  });

  @override
  Widget build(BuildContext context) {
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
          highlightColor: gradientColors.last.withOpacity(0.05),
          splashColor: gradientColors.first.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon with Premium Gradient Background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 20),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          if (isSparkle) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.flare_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Arrow
                Container(
                  padding: const EdgeInsets.all(8),
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
          ),
        ),
      ),
    );
  }
}

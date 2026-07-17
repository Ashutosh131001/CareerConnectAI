import 'package:careerconnect/application/applicationModel.dart';
import 'package:careerconnect/chatbot/chatController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatScreen extends StatelessWidget {
  final ApplicationModel application;

  const AiChatScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    // Inject the controller with a unique tag based on the application ID
    final AiChatController controller = Get.put(
      AiChatController(application: application),
      tag: application.id,
    );

    const primaryColor = Color(0xFF0F172A);
    const backgroundColor = Color(0xFFF8FAFC);

    // Premium Gradients
    const aiGradient = [Color(0xFF7C3AED), Color(0xFF8B5CF6)]; // Violet
    const userGradient = [Color(0xFF1D4ED8), Color(0xFF3B82F6)]; // Blue

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(context, primaryColor, application),

            // Chat Messages List
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 24.0,
                  ),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return _PremiumChatBubble(
                      text: message.text,
                      isUser: message.isUser,
                      aiGradient: aiGradient,
                      userGradient: userGradient,
                    );
                  },
                );
              }),
            ),

            // Loading Indicator
            Obx(() {
              if (controller.isLoading.value) {
                return _buildTypingIndicator(aiGradient.last);
              }
              return const SizedBox.shrink();
            }),

            // Premium Input Bar
            _buildInputConsole(controller, aiGradient),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(
    BuildContext context,
    Color primaryColor,
    ApplicationModel app,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFF8B5CF6),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Friday',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Application Context Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Context: ${app.companyName} (${app.status})',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(Color aiAccent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: aiAccent,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Friday is thinking...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputConsole(
    AiChatController controller,
    List<Color> aiGradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, -10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: TextField(
                controller: controller.textController,
                style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'Ask for prep tips, guidance...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Obx(() {
            final isLoad = controller.isLoading.value;
            return Container(
              decoration: BoxDecoration(
                gradient: isLoad
                    ? LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade400],
                      )
                    : LinearGradient(
                        colors: aiGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                shape: BoxShape.circle,
                boxShadow: isLoad
                    ? null
                    : [
                        BoxShadow(
                          color: aiGradient.last.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: isLoad ? null : () => controller.sendMessage(),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _PremiumChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final List<Color> aiGradient;
  final List<Color> userGradient;

  const _PremiumChatBubble({
    required this.text,
    required this.isUser,
    required this.aiGradient,
    required this.userGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            // Glowing AI Avatar
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: aiGradient.last.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: aiGradient.last,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isUser ? null : Colors.white,
                gradient: isUser
                    ? LinearGradient(
                        colors: userGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: Radius.circular(isUser ? 24 : 6), // Squircle edge
                  bottomRight: Radius.circular(
                    isUser ? 6 : 24,
                  ), // Squircle edge
                ),
                boxShadow: [
                  if (!isUser)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  else
                    BoxShadow(
                      color: userGradient.last.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 15,
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),

          if (isUser)
            const SizedBox(width: 32), // Padding buffer for user messages
          if (!isUser)
            const SizedBox(width: 32), // Padding buffer for AI messages
        ],
      ),
    );
  }
}

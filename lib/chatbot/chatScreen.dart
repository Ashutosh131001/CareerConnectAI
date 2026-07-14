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
    // This prevents memory overlap if the student opens multiple chats
    final AiChatController controller = Get.put(
      AiChatController(application: application),
      tag: application.id,
    );

    const primaryColor = Color(0xFF0F172A);
    const aiAccent = Color(0xFF8B5CF6); // Purple for Friday
    const userAccent = Color(0xFF2563EB); // Blue for Student

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        iconTheme: const IconThemeData(color: primaryColor),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: aiAccent, size: 18),
                SizedBox(width: 8),
                Text(
                  'Friday',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Text(
              'Context: ${application.companyName} (${application.status})',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Messages List
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(20.0),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return _ChatBubble(
                      text: message.text,
                      isUser: message.isUser,
                      aiAccent: aiAccent,
                      userAccent: userAccent,
                    );
                  },
                );
              }),
            ),

            // Loading Indicator
            Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: aiAccent,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Friday is typing...',
                        style: TextStyle(
                          color: aiAccent,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      decoration: InputDecoration(
                        hintText: 'Ask for prep tips, guidance...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => controller.sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() {
                    return CircleAvatar(
                      radius: 24,
                      backgroundColor: controller.isLoading.value
                          ? Colors.grey.shade300
                          : aiAccent,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.sendMessage(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------
// SEPARATED WIDGETS
// -----------------------------------------------------------------

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final Color aiAccent;
  final Color userAccent;

  const _ChatBubble({
    required this.text,
    required this.isUser,
    required this.aiAccent,
    required this.userAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: aiAccent.withOpacity(0.1),
              child: Icon(Icons.auto_awesome, color: aiAccent, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? userAccent : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                border: isUser ? null : Border.all(color: Colors.grey.shade200),
                boxShadow: isUser
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser)
            const SizedBox(width: 24), // Buffer on the right for user messages
        ],
      ),
    );
  }
}

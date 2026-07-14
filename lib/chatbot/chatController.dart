import 'package:careerconnect/application/applicationModel.dart';
import 'package:careerconnect/chatbot/airepo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class AiChatController extends GetxController {
  final ApplicationModel application;
  late final OpenAIService _openAIService;

  AiChatController({required this.application});

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeAI();
  }

  void _initializeAI() {
    // The exact same context-aware prompt you agreed on
    final String prompt = '''
      You are jarvis, an expert AI Career Assistant for The NorthCap University students. 
      The student you are talking to has applied for the ${application.jobRole} role at ${application.companyName}.
      Their current application status is: "${application.status}".
      
      Your goal is to help them based on this status. 
      - If they are 'Pending', reassure them and suggest how to prepare while waiting.
      - If they are 'Selected', congratulate them and advise on onboarding.
      - If they are 'Interview', give them specific interview prep tips for ${application.jobRole} roles at ${application.companyName}.
      
      Keep your answers concise, encouraging, and highly specific to their current situation.
    ''';

    // Inject the service here
    _openAIService = OpenAIService(prompt);
    
    messages.add(ChatMessage(
      text: 'Hi! I see your application for ${application.companyName} is currently ${application.status}. How can I help you prepare?',
      isUser: false,
    ));
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(ChatMessage(text: text, isUser: true));
    textController.clear();
    isLoading.value = true;

    // Send to OpenAI
    final response = await _openAIService.sendMessage(text);

    messages.add(ChatMessage(text: response, isUser: false));
    isLoading.value = false;
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
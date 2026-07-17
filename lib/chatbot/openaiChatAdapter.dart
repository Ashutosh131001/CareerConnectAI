// lib/chatbot/openai_chat_adapter.dart

import 'dart:convert';
import 'package:careerconnect/chatbot/chatClient.dart';
import 'package:http/http.dart' as http;

class OpenAIChatAdapter implements ChatClient {
  // Replace 'careerconnect-413fb' with your actual project ID if it differs in the URL you received
  static const String _endpoint =
      'https://us-central1-careerconnect-413fb.cloudfunctions.net/api/chat';

  final String _systemInstruction;

  // We store the system instruction to send to the Cloud Function with each request
  OpenAIChatAdapter(this._systemInstruction);

  @override
  Future<String> sendMessage(String text) async {
    try {
      // Make the POST request to YOUR backend, not OpenAI
      final response = await http
          .post(
            Uri.parse(_endpoint),
            headers: {
              'Content-Type': 'application/json',
              // Notice: No Authorization header needed here! The Cloud Function handles the secret key.
            },
            body: jsonEncode({
              'message': text,
              'systemInstruction': _systemInstruction,
            }),
          )
          .timeout(const Duration(seconds: 30));

      // Parse the response from your Cloud Function
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Your Cloud Function returns the response inside the "answer" key
        return data['answer'];
      } else {
        return 'Connection Error: ${response.statusCode} - The AI Assistant is temporarily unavailable.';
      }
    } catch (e) {
      return 'Failed to connect to Friday. Please try again later.';
    }
  }
}

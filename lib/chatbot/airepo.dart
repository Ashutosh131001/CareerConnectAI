import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAIService {
  // TODO: Replace with your actual OpenAI API Key
  static const String _apiKey = '';
  static const String _endpoint = 'https://api.openai.com/v1/chat/completions';

  // This list acts as the AI's memory
  final List<Map<String, String>> _messages = [];

  OpenAIService(String systemInstruction) {
    // Inject the context-aware prompt as a 'system' role immediately
    _messages.add({'role': 'system', 'content': systemInstruction});
  }

  Future<String> sendMessage(String text) async {
    try {
      // 1. Add the student's new message to the memory
      _messages.add({'role': 'user', 'content': text});

      // 2. Make the REST API call to OpenAI
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model':
              'gpt-3.5-turbo', // You can change this to gpt-4o-mini if you have access
          'messages': _messages,
          'temperature':
              0.7, // Makes it slightly creative but still professional
        }),
      );

      // 3. Parse the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];

        // 4. Save Friday's response to the memory so it remembers for the next turn
        _messages.add({'role': 'assistant', 'content': aiResponse});

        return aiResponse;
      } else {
        return 'Connection Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Failed to connect to Friday: $e';
    }
  }
}

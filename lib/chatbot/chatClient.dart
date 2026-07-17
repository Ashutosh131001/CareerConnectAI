// lib/chatbot/chat_client.dart

abstract class ChatClient {
  /// Sends a message to the LLM and returns the text response.
  Future<String> sendMessage(String text);
}
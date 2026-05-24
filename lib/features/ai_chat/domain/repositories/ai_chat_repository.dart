import 'dart:io';

abstract class AiChatRepository {
  Future<String> sendMessage(String message);
  Future<String> analyzeMedicine(File imageFile);
}
part of 'ai_chat_bloc.dart';

abstract class AiChatEvent {}

class SendMessageEvent extends AiChatEvent {
  final String message;
  SendMessageEvent({required this.message});
}

class ClearChatEvent extends AiChatEvent {}

class AnalyzeMedicineEvent extends AiChatEvent {
  final File imageFile;
  AnalyzeMedicineEvent({required this.imageFile});
}

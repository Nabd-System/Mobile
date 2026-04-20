enum MessageType { user, ai }

class ChatMessageModel {
  final String message;
  final MessageType type;
  final DateTime timestamp;

  ChatMessageModel({
    required this.message,
    required this.type,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ChatMessageModel.user(String message) {
    return ChatMessageModel(message: message, type: MessageType.user);
  }

  factory ChatMessageModel.ai(String message) {
    return ChatMessageModel(message: message, type: MessageType.ai);
  }

  bool get isUser => type == MessageType.user;
  bool get isAi => type == MessageType.ai;
}

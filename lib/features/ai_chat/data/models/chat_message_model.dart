enum MessageType { user, ai, medicineAnalysis }

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

  factory ChatMessageModel.medicineAnalysis(String message) {
    return ChatMessageModel(message: message, type: MessageType.medicineAnalysis);
  }

  bool get isUser => type == MessageType.user;
  bool get isAi => type == MessageType.ai;
  bool get isMedicineAnalysis => type == MessageType.medicineAnalysis;
}
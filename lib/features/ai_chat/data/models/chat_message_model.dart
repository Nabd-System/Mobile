import 'package:nabd/features/ai_chat/data/models/skin_analysis_model.dart';

enum MessageType { user, ai, medicineAnalysis, skinAnalysis }

class ChatMessageModel {
  final String message;
  final MessageType type;
  final DateTime timestamp;
  final SkinAnalysisModel? skinAnalysis;

  ChatMessageModel({
    required this.message,
    required this.type,
    DateTime? timestamp,
    this.skinAnalysis,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ChatMessageModel.user(String message) {
    return ChatMessageModel(message: message, type: MessageType.user);
  }

  factory ChatMessageModel.ai(String message) {
    return ChatMessageModel(message: message, type: MessageType.ai);
  }

  factory ChatMessageModel.medicineAnalysis(String message) {
    return ChatMessageModel(
      message: message,
      type: MessageType.medicineAnalysis,
    );
  }

  factory ChatMessageModel.skinAnalysis(SkinAnalysisModel data) {
    return ChatMessageModel(
      message: '',
      type: MessageType.skinAnalysis,
      skinAnalysis: data,
    );
  }

  bool get isUser => type == MessageType.user;
  bool get isAi => type == MessageType.ai;
  bool get isMedicineAnalysis => type == MessageType.medicineAnalysis;
  bool get isSkinAnalysis => type == MessageType.skinAnalysis;
}
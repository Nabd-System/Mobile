import 'dart:io';
import 'package:nabd/features/ai_chat/data/models/skin_analysis_model.dart';

abstract class AiChatRepository {
  Future<String> sendMessage(String message);
  Future<String> analyzeMedicine(File imageFile);
  Future<SkinAnalysisModel> analyzeSkin(File imageFile);
}
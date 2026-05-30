import 'dart:io';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/ai_chat/data/datasources/ai_chat_remote_datasource.dart';
import 'package:nabd/features/ai_chat/data/models/skin_analysis_model.dart';
import 'package:nabd/features/ai_chat/domain/repositories/ai_chat_repository.dart';

class AiChatRepositoryImpl implements AiChatRepository {
  final AiChatRemoteDatasource remoteDatasource;

  AiChatRepositoryImpl({required this.remoteDatasource});

  @override
  Future<String> sendMessage(String message) async {
    try {
      return await remoteDatasource.sendMessage(message);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to get AI response');
    }
  }

  @override
  Future<String> analyzeMedicine(File imageFile) async {
    try {
      return await remoteDatasource.analyzeMedicine(imageFile);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to analyze medicine image');
    }
  }

  @override
  Future<SkinAnalysisModel> analyzeSkin(File imageFile) async {
    try {
      return await remoteDatasource.analyzeSkin(imageFile);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to analyze skin image');
    }
  }
}
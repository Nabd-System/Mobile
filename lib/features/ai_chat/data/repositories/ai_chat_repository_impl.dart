import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/ai_chat/data/datasources/ai_chat_remote_datasource.dart';
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
}

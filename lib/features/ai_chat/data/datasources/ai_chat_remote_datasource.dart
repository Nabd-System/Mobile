import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';

class AiChatRemoteDatasource {
  Future<String> sendMessage(String message) async {
    final response = await ApiClient.post(
      endpoint: AppEndpoints.aiChat,
      data: {'message': message},
    );

    return response.data['reply'] ?? 'Sorry, I could not understand that.';
  }
}

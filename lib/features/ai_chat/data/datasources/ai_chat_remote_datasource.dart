import 'dart:io';
import 'package:dio/dio.dart';
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

  Future<String> analyzeMedicine(File imageFile) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    final response = await ApiClient.post(
      endpoint: AppEndpoints.medicineAnalysis,
      data: formData,
    );

    return response.data['result'] ?? 'Could not analyze the medicine.';
  }
}
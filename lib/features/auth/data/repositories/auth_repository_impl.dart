import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';
import 'package:nabd/features/auth/data/models/login_response_model.dart';

class AuthRepo {
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final response = await ApiClient.post(
      endpoint: AppEndpoints.login,
      data: {'username': username, 'password': password},
    );
    return LoginResponseModel.fromJson(response.data['data']);
  }
}

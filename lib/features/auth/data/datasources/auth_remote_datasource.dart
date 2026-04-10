import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';
import 'package:nabd/features/auth/data/models/login_request_model.dart';
import 'package:nabd/features/auth/data/models/login_response_model.dart';

class AuthRemoteDatasource {
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await ApiClient.post(
      endpoint: AppEndpoints.login,
      data: request.toJson(),
    );
    return LoginResponseModel.fromJson(response.data['data']);
  }
}

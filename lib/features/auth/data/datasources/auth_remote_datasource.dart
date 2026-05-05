import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';
import 'package:nabd/features/auth/data/models/login_request_model.dart';
import 'package:nabd/features/auth/data/models/login_response_model.dart';
import 'package:nabd/features/auth/data/models/forgot_password_request_model.dart';
import 'package:nabd/features/auth/data/models/reset_password_request_model.dart';

class AuthRemoteDatasource {
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await ApiClient.post(
      endpoint: AppEndpoints.login,
      data: request.toJson(),
    );
    return LoginResponseModel.fromJson(response.data['data']);
  }

  Future<void> logout(String refreshToken) async {
    await ApiClient.post(
      endpoint: AppEndpoints.logout,
      queryParameters: {'RefreshToken': refreshToken},
    );
  }

  Future<void> forgotPassword({required String email}) async {
    final request = ForgotPasswordRequestModel(email: email);
    final response = await ApiClient.post(
      endpoint: AppEndpoints.forgetPassword,
      data: request.toJson(),
    );

    if (response.data['isSuccess'] == false) {
      throw Exception(response.data['message'] ?? 'Something went wrong');
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final request = ResetPasswordRequestModel(
      email: email,
      otp: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
    final response = await ApiClient.post(
      endpoint: AppEndpoints.resetPassword,
      data: request.toJson(),
    );

    if (response.data['isSuccess'] == false) {
      throw Exception(response.data['message'] ?? 'Something went wrong');
    }
  }
}

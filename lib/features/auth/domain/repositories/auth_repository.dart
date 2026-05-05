import 'package:nabd/features/auth/data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  });

  bool isLoggedIn();

  Future<void> logout();

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  });
}

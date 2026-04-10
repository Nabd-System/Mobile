import 'package:nabd/features/auth/data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  });

  bool isLoggedIn();

  Future<void> logout();
}

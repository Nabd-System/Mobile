import 'package:nabd/core/services/remote/dio_provider.dart';
import 'package:nabd/core/services/remote/endpoints.dart';
import 'package:nabd/features/auth/data/models/login_response_model.dart';

class AuthRepo {
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    // بنبعت الـ request للـ API
    final response = await DioProvider.post(
      endpoint: AppEndpoints.login,
      data: {'username': username, 'password': password},
    );

    // الـ API بترجع { isSuccess, message, data: {...} }
    // إحنا محتاجين الـ data جوه
    return LoginResponseModel.fromJson(response.data['data']);
  }
}

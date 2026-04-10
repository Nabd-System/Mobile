import 'package:nabd/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:nabd/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:nabd/features/auth/data/models/login_request_model.dart';
import 'package:nabd/features/auth/data/models/login_response_model.dart';
import 'package:nabd/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final request = LoginRequestModel(username: username, password: password);

    final user = await remoteDatasource.login(request);
    await localDatasource.saveUserData(user);
    return user;
  }

  @override
  bool isLoggedIn() {
    return localDatasource.isLoggedIn();
  }

  @override
  Future<void> logout() async {
    await localDatasource.clearUserData();
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/storage/app_local_storage.dart';
import 'package:nabd/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc({required this.authRepo}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); // ابعت loading أول حاجة

    try {
      final user = await authRepo.login(
        username: event.username,
        password: event.password,
      );

      // ✅ حفظ الـ token في SharedPreferences
      await AppLocalStorage.cacheData(AppLocalStorage.token, user.accessToken);

      emit(LoginSuccess(user: user));
    } catch (e) {
      emit(LoginFailure(message: e.toString()));
    }
  }
}

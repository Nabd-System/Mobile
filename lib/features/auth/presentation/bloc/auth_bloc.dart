import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/auth/domain/repositories/auth_repository.dart';
import 'package:nabd/features/auth/presentation/bloc/auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await authRepository.login(
        username: event.username,
        password: event.password,
      );
      emit(LoginSuccess(user: user));
    } on UnauthorizedException {
      emit(LoginFailure(message: 'Invalid username or password'));
    } on NetworkException {
      emit(LoginFailure(message: 'No internet connection'));
    } on ServerException catch (e) {
      emit(LoginFailure(message: e.message));
    } catch (e) {
      emit(LoginFailure(message: 'Something went wrong. Please try again'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(LogoutLoading());
    await authRepository.logout();
    emit(LogoutSuccess());
  }
}

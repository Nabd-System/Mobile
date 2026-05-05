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
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  // ==================== Login ====================
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

  // ==================== Logout ====================
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(LogoutLoading());
    await authRepository.logout();
    emit(LogoutSuccess());
  }

  // ==================== Forgot Password ====================
  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ForgotPasswordLoading());

    try {
      await authRepository.forgotPassword(email: event.email);
      emit(ForgotPasswordSuccess(message: 'Email was sent successfully'));
    } on NetworkException {
      emit(ForgotPasswordFailure(message: 'No internet connection'));
    } on ServerException catch (e) {
      emit(ForgotPasswordFailure(message: e.message));
    } catch (e) {
      emit(
        ForgotPasswordFailure(
          message: 'Something went wrong. Please try again',
        ),
      );
    }
  }

  // ==================== Reset Password ====================
  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(ResetPasswordLoading());

    try {
      await authRepository.resetPassword(
        email: event.email,
        otp: event.otp,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );
      emit(ResetPasswordSuccess());
    } on NetworkException {
      emit(ResetPasswordFailure(message: 'No internet connection'));
    } on ServerException catch (e) {
      emit(ResetPasswordFailure(message: e.message));
    } catch (e) {
      emit(
        ResetPasswordFailure(message: 'Something went wrong. Please try again'),
      );
    }
  }
}

import 'package:nabd/features/auth/data/models/login_response_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

// ==================== Login ====================
class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final LoginResponseModel user;
  LoginSuccess({required this.user});
}

class LoginFailure extends AuthState {
  final String message;
  LoginFailure({required this.message});
}

// ==================== Logout ====================
class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {}

// ==================== Forgot Password ====================
class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  final String message;
  ForgotPasswordSuccess({required this.message});
}

class ForgotPasswordFailure extends AuthState {
  final String message;
  ForgotPasswordFailure({required this.message});
}

// ==================== Reset Password ====================
class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class ResetPasswordFailure extends AuthState {
  final String message;
  ResetPasswordFailure({required this.message});
}

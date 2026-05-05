part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});
}

class LogoutRequested extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested({required this.email});
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequested({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });
}

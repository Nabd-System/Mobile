import 'package:nabd/features/auth/data/models/login_response_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final LoginResponseModel user;
  LoginSuccess({required this.user});
}

class LoginFailure extends AuthState {
  final String message;
  LoginFailure({required this.message});
}

class LogoutLoading extends AuthState {} 

class LogoutSuccess extends AuthState {}

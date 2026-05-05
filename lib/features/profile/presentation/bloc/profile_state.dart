part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

// ==================== Get Profile ====================
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final PatientProfileModel profile;
  ProfileLoaded({required this.profile});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}

// ==================== Change Password ====================
class ChangePasswordLoading extends ProfileState {}

class ChangePasswordSuccess extends ProfileState {}

class ChangePasswordFailure extends ProfileState {
  final String message;
  ChangePasswordFailure({required this.message});
}

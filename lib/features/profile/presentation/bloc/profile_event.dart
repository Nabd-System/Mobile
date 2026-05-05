part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class RefreshProfileEvent extends ProfileEvent {}

class ChangePasswordEvent extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordEvent({required this.oldPassword, required this.newPassword});
}

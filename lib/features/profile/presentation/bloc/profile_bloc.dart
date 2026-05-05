import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/profile/data/models/patient_profile_model.dart';
import 'package:nabd/features/profile/domain/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<GetProfileEvent>(_onGetProfile);
    on<RefreshProfileEvent>(_onRefreshProfile);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  // ==================== Get Profile ====================
  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final cached = profileRepository.getCachedProfile();
    if (cached != null) {
      emit(ProfileLoaded(profile: cached));
    } else {
      emit(ProfileLoading());
    }

    try {
      final profile = await profileRepository.getProfile();
      emit(ProfileLoaded(profile: profile));
    } on NetworkException {
      if (cached == null) {
        emit(ProfileError(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      if (cached == null) {
        emit(ProfileError(message: e.message));
      }
    } catch (_) {
      if (cached == null) {
        emit(ProfileError(message: 'Failed to load profile'));
      }
    }
  }

  // ==================== Refresh Profile ====================
  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepository.getProfile();
      emit(ProfileLoaded(profile: profile));
    } on NetworkException {
      emit(ProfileError(message: 'No internet connection'));
    } on ServerException catch (e) {
      emit(ProfileError(message: e.message));
    } catch (_) {
      emit(ProfileError(message: 'Failed to load profile'));
    }
  }

  // ==================== Change Password ====================
  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ChangePasswordLoading());
    try {
      await profileRepository.changePassword(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      emit(ChangePasswordSuccess());
    } on NetworkException {
      emit(ChangePasswordFailure(message: 'No internet connection'));
    } on ServerException catch (e) {
      emit(ChangePasswordFailure(message: e.message));
    } catch (_) {
      emit(
        ChangePasswordFailure(
          message: 'Something went wrong. Please try again',
        ),
      );
    }
  }
}

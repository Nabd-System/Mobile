import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/home/data/models/doctor_search_model.dart';
import 'package:nabd/features/home/domain/repositories/home_repository.dart';
import 'package:nabd/features/appointments/data/models/appointment_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(const HomeState()) {
    on<SearchDoctorsEvent>(_onSearchDoctors);
    on<ClearSearchEvent>(_onClearSearch);
    on<GetUpcomingAppointmentEvent>(_onGetUpcomingAppointment);
  }

  Future<void> _onSearchDoctors(
    SearchDoctorsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final searchTerm = event.searchTerm.trim();

    if (searchTerm.isEmpty) {
      emit(state.copyWith(
        searchResults: [],
        searchTerm: '',
        clearError: true,
      ));
      return;
    }

    emit(state.copyWith(
      isSearching: true,
      searchTerm: searchTerm,
      clearError: true,
    ));

    try {
      final results = await homeRepository.searchDoctors(searchTerm);
      emit(state.copyWith(
        searchResults: results,
        isSearching: false,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isSearching: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSearching: false,
        errorMessage: 'Failed to search doctors',
      ));
    }
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      searchResults: [],
      searchTerm: '',
      clearError: true,
    ));
  }

  Future<void> _onGetUpcomingAppointment(
    GetUpcomingAppointmentEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoadingAppointment: true, clearError: true));

    try {
      final appointment = await homeRepository.getUpcomingAppointment();
      emit(state.copyWith(
        upcomingAppointment: appointment,
        isLoadingAppointment: false,
        hasNoUpcoming: appointment == null,
      ));
    } on ServerException catch (e) {
      emit(state.copyWith(
        isLoadingAppointment: false,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingAppointment: false,
        errorMessage: 'Failed to load upcoming appointment',
      ));
    }
  }
}
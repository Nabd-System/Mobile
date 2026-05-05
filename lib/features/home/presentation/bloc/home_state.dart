part of 'home_bloc.dart';

class HomeState {
  final List<DoctorSearchModel> searchResults;
  final bool isSearching;
  final String? errorMessage;
  final String searchTerm;

  // Upcoming Appointment
  final AppointmentModel? upcomingAppointment;
  final bool isLoadingAppointment;
  final bool hasNoUpcoming;

  const HomeState({
    this.searchResults = const [],
    this.isSearching = false,
    this.errorMessage,
    this.searchTerm = '',
    this.upcomingAppointment,
    this.isLoadingAppointment = false,
    this.hasNoUpcoming = false,
  });

  bool get hasResults => searchResults.isNotEmpty;
  bool get showResults => searchTerm.isNotEmpty;
  bool get hasUpcomingAppointment => upcomingAppointment != null;

  HomeState copyWith({
    List<DoctorSearchModel>? searchResults,
    bool? isSearching,
    String? errorMessage,
    String? searchTerm,
    AppointmentModel? upcomingAppointment,
    bool? isLoadingAppointment,
    bool? hasNoUpcoming,
    bool clearError = false,
    bool clearUpcomingAppointment = false, // ✅ جديد
  }) {
    return HomeState(
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      searchTerm: searchTerm ?? this.searchTerm,
      // ✅ الفيكس: لو clearUpcomingAppointment = true → نمسح القديم
      upcomingAppointment: clearUpcomingAppointment
          ? null
          : upcomingAppointment ?? this.upcomingAppointment,
      isLoadingAppointment: isLoadingAppointment ?? this.isLoadingAppointment,
      hasNoUpcoming: hasNoUpcoming ?? this.hasNoUpcoming,
    );
  }
}

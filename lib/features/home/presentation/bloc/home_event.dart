part of 'home_bloc.dart';

abstract class HomeEvent {}

class SearchDoctorsEvent extends HomeEvent {
  final String searchTerm;
  SearchDoctorsEvent({required this.searchTerm});
}

class ClearSearchEvent extends HomeEvent {}

class GetUpcomingAppointmentEvent extends HomeEvent {}

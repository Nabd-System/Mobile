import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/features/home/data/datasources/home_remote_datasource.dart';
import 'package:nabd/features/home/data/models/doctor_search_model.dart';
import 'package:nabd/features/home/domain/repositories/home_repository.dart';
import 'package:nabd/features/appointments/data/models/appointment_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource remoteDatasource;

  HomeRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<DoctorSearchModel>> searchDoctors(String searchTerm) async {
    try {
      return await remoteDatasource.searchDoctors(searchTerm);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to search doctors');
    }
  }

  @override
  Future<AppointmentModel?> getUpcomingAppointment() async {
    try {
      return await remoteDatasource.getUpcomingAppointment();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to load upcoming appointment');
    }
  }
}

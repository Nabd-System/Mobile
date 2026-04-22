import 'package:dartz/dartz.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/core/errors/failures.dart';
import 'package:nabd/features/medical_records/data/datasources/medical_records_remote_datasource.dart';
import 'package:nabd/features/medical_records/data/models/paginated_response.dart';
import 'package:nabd/features/medical_records/data/models/visit_model.dart';
import 'package:nabd/features/medical_records/data/models/visit_details_model.dart';
import 'package:nabd/features/medical_records/data/models/allergy_model.dart';
import 'package:nabd/features/medical_records/data/models/allergy_details_model.dart';
import 'package:nabd/features/medical_records/data/models/chronic_disease_model.dart';
import 'package:nabd/features/medical_records/data/models/chronic_disease_details_model.dart';
import 'package:nabd/features/medical_records/data/models/medical_history_model.dart';
import 'package:nabd/features/medical_records/data/models/medical_history_details_model.dart';
import 'package:nabd/features/medical_records/data/models/prescription_model.dart';
import 'package:nabd/features/medical_records/data/models/prescription_details_model.dart';
import 'package:nabd/features/medical_records/domain/repositories/medical_records_repository.dart';

class MedicalRecordsRepositoryImpl implements MedicalRecordsRepository {
  final MedicalRecordsRemoteDataSource remoteDataSource;

  MedicalRecordsRepositoryImpl({required this.remoteDataSource});

  // ==================== Visits ====================

  @override
  Future<Either<Failure, PaginatedResponse<VisitModel>>> getVisitHistory({
    int pageIndex = 1,
    int pageSize = 10,
    String? visitNumber,
    String? visitStatus,
  }) async {
    try {
      final result = await remoteDataSource.getVisitHistory(
        pageIndex: pageIndex,
        pageSize: pageSize,
        visitNumber: visitNumber,
        visitStatus: visitStatus,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, VisitDetailsModel>> getVisitDetails(
    int visitId,
  ) async {
    try {
      final result = await remoteDataSource.getVisitDetails(visitId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  // ==================== Allergies ====================

  @override
  Future<Either<Failure, PaginatedResponse<AllergyModel>>> getAllergies({
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    try {
      final result = await remoteDataSource.getAllergies(
        pageIndex: pageIndex,
        pageSize: pageSize,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AllergyDetailsModel>> getAllergyDetails(int id) async {
    try {
      final result = await remoteDataSource.getAllergyDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  // ==================== Chronic Diseases ====================

  @override
  Future<Either<Failure, List<ChronicDiseaseModel>>>
  getChronicDiseases() async {
    try {
      final result = await remoteDataSource.getChronicDiseases();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ChronicDiseaseDetailsModel>> getChronicDiseaseDetails(
    int id,
  ) async {
    try {
      final result = await remoteDataSource.getChronicDiseaseDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  // ==================== Medical History ====================

  @override
  Future<Either<Failure, List<MedicalHistoryModel>>> getMedicalHistory() async {
    try {
      final result = await remoteDataSource.getMedicalHistory();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, MedicalHistoryDetailsModel>> getMedicalHistoryDetails(
    int id,
  ) async {
    try {
      final result = await remoteDataSource.getMedicalHistoryDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  // ==================== Prescriptions ====================

  @override
  Future<Either<Failure, List<PrescriptionModel>>> getPrescriptions() async {
    try {
      final result = await remoteDataSource.getPrescriptions();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, PrescriptionDetailsModel>> getPrescriptionDetails(
    int id,
  ) async {
    try {
      final result = await remoteDataSource.getPrescriptionDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> exportPrescription(int prescriptionId) async {
    try {
      final filePath = await remoteDataSource.exportPrescription(
        prescriptionId,
      );
      return Right(filePath);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to download prescription'));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:nabd/core/errors/failures.dart';
import 'package:nabd/features/medical_records/data/models/allergy_details_model.dart';
import 'package:nabd/features/medical_records/data/models/allergy_model.dart';
import 'package:nabd/features/medical_records/data/models/chronic_disease_details_model.dart';
import 'package:nabd/features/medical_records/data/models/chronic_disease_model.dart';
import 'package:nabd/features/medical_records/data/models/lab_analysis_model.dart';
import 'package:nabd/features/medical_records/data/models/lab_result_details_model.dart';
import 'package:nabd/features/medical_records/data/models/lab_result_model.dart';
import 'package:nabd/features/medical_records/data/models/medical_history_details_model.dart';
import 'package:nabd/features/medical_records/data/models/medical_history_model.dart';
import 'package:nabd/features/medical_records/data/models/paginated_response.dart';
import 'package:nabd/features/medical_records/data/models/prescription_details_model.dart';
import 'package:nabd/features/medical_records/data/models/prescription_model.dart';
import 'package:nabd/features/medical_records/data/models/radiology_details_model.dart';
import 'package:nabd/features/medical_records/data/models/radiology_model.dart';
import 'package:nabd/features/medical_records/data/models/visit_details_model.dart';
import 'package:nabd/features/medical_records/data/models/visit_model.dart';

abstract class MedicalRecordsRepository {
  // ==================== Visits ====================
  Future<Either<Failure, PaginatedResponse<VisitModel>>> getVisitHistory({
    int pageIndex,
    int pageSize,
    String? visitNumber,
    String? visitStatus,
  });

  Future<Either<Failure, VisitDetailsModel>> getVisitDetails(int visitId);

  // ==================== Allergies ====================
  Future<Either<Failure, PaginatedResponse<AllergyModel>>> getAllergies({
    int pageIndex,
    int pageSize,
  });

  Future<Either<Failure, AllergyDetailsModel>> getAllergyDetails(int id);

  // ==================== Chronic Diseases ====================
  Future<Either<Failure, List<ChronicDiseaseModel>>> getChronicDiseases();

  Future<Either<Failure, ChronicDiseaseDetailsModel>> getChronicDiseaseDetails(
    int id,
  );

  // ==================== Medical History ====================
  Future<Either<Failure, List<MedicalHistoryModel>>> getMedicalHistory();

  Future<Either<Failure, MedicalHistoryDetailsModel>> getMedicalHistoryDetails(
    int id,
  );

  // ==================== Prescriptions ====================
  Future<Either<Failure, List<PrescriptionModel>>> getPrescriptions();

  Future<Either<Failure, PrescriptionDetailsModel>> getPrescriptionDetails(
    int id,
  );

  Future<Either<Failure, String>> exportPrescription(int prescriptionId);

  // ==================== Lab Results ====================
  Future<Either<Failure, List<LabResultModel>>> getLabResults();

  Future<Either<Failure, LabResultDetailsModel>> getLabResultDetails(int id);

  Future<Either<Failure, LabAnalysisModel>> getLabAnalysis(int id);

  Future<Either<Failure, String>> exportLabResult(int labResultId);

  // ==================== Radiology ==================== ← جديد
  Future<Either<Failure, List<RadiologyModel>>> getRadiology();

  Future<Either<Failure, RadiologyDetailsModel>> getRadiologyDetails(int id);

  Future<Either<Failure, String>> exportRadiology(int id);
}

import 'package:path_provider/path_provider.dart';
import 'package:nabd/core/errors/exceptions.dart';
import 'package:nabd/core/network/api_client.dart';
import 'package:nabd/core/network/endpoints.dart';
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
import 'package:nabd/features/medical_records/data/models/lab_result_model.dart';
import 'package:nabd/features/medical_records/data/models/lab_result_details_model.dart';
import 'package:nabd/features/medical_records/data/models/lab_analysis_model.dart';
import 'package:nabd/features/medical_records/data/models/radiology_model.dart';
import 'package:nabd/features/medical_records/data/models/radiology_details_model.dart';
import 'package:dio/dio.dart';
import 'package:nabd/core/constants/storage_keys.dart';
import 'package:nabd/core/storage/app_local_storage.dart';

abstract class MedicalRecordsRemoteDataSource {
  Future<PaginatedResponse<VisitModel>> getVisitHistory({
    int pageIndex = 1,
    int pageSize = 10,
    String? visitNumber,
    String? visitStatus,
  });
  Future<VisitDetailsModel> getVisitDetails(int visitId);

  Future<PaginatedResponse<AllergyModel>> getAllergies({
    int pageIndex = 1,
    int pageSize = 10,
  });
  Future<AllergyDetailsModel> getAllergyDetails(int id);

  Future<List<ChronicDiseaseModel>> getChronicDiseases();
  Future<ChronicDiseaseDetailsModel> getChronicDiseaseDetails(int id);

  Future<List<MedicalHistoryModel>> getMedicalHistory();
  Future<MedicalHistoryDetailsModel> getMedicalHistoryDetails(int id);

  Future<List<PrescriptionModel>> getPrescriptions();
  Future<PrescriptionDetailsModel> getPrescriptionDetails(int id);
  Future<String> exportPrescription(int prescriptionId);

  Future<List<LabResultModel>> getLabResults();
  Future<LabResultDetailsModel> getLabResultDetails(int id);
  Future<LabAnalysisModel> getLabAnalysis(int id);
  Future<String> exportLabResult(int labResultId);

  // ==================== Radiology ==================== ← جديد
  Future<List<RadiologyModel>> getRadiology();
  Future<RadiologyDetailsModel> getRadiologyDetails(int id);
  Future<String> exportRadiology(int id);
}

class MedicalRecordsRemoteDataSourceImpl
    implements MedicalRecordsRemoteDataSource {
  // ==================== Visits ====================

  @override
  Future<PaginatedResponse<VisitModel>> getVisitHistory({
    int pageIndex = 1,
    int pageSize = 10,
    String? visitNumber,
    String? visitStatus,
  }) async {
    final queryParams = <String, dynamic>{
      'PageIndex': pageIndex,
      'PageSize': pageSize,
    };

    if (visitNumber != null && visitNumber.isNotEmpty) {
      queryParams['VisitNumber'] = visitNumber;
    }
    if (visitStatus != null && visitStatus.isNotEmpty) {
      queryParams['VisitStatus'] = visitStatus;
    }

    final response = await ApiClient.get(
      endpoint: AppEndpoints.visitHistory,
      queryParameters: queryParams,
    );

    if (response.data['isSuccess'] == true) {
      return PaginatedResponse<VisitModel>.fromJson(
        response.data['data'],
        (json) => VisitModel.fromJson(json),
      );
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load visits',
      );
    }
  }

  @override
  Future<VisitDetailsModel> getVisitDetails(int visitId) async {
    final response = await ApiClient.get(
      endpoint: '${AppEndpoints.visitDetails}/$visitId',
    );

    if (response.data['isSuccess'] == true) {
      return VisitDetailsModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load visit details',
      );
    }
  }

  // ==================== Allergies ====================

  @override
  Future<PaginatedResponse<AllergyModel>> getAllergies({
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    final queryParams = <String, dynamic>{
      'PageIndex': pageIndex,
      'PageSize': pageSize,
    };

    final response = await ApiClient.get(
      endpoint: AppEndpoints.allergies,
      queryParameters: queryParams,
    );

    if (response.data['isSuccess'] == true) {
      return PaginatedResponse<AllergyModel>.fromJson(
        response.data['data'],
        (json) => AllergyModel.fromJson(json),
      );
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load allergies',
      );
    }
  }

  @override
  Future<AllergyDetailsModel> getAllergyDetails(int id) async {
    final response = await ApiClient.get(
      endpoint: '${AppEndpoints.allergyDetails}/$id',
    );

    if (response.data['isSuccess'] == true) {
      return AllergyDetailsModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load allergy details',
      );
    }
  }

  // ==================== Chronic Diseases ====================

  @override
  Future<List<ChronicDiseaseModel>> getChronicDiseases() async {
    final response = await ApiClient.get(
      endpoint: AppEndpoints.chronicDiseases,
    );

    if (response.data['isSuccess'] == true) {
      final List<dynamic> list = response.data['data'] ?? [];
      return list.map((item) => ChronicDiseaseModel.fromJson(item)).toList();
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load chronic diseases',
      );
    }
  }

  @override
  Future<ChronicDiseaseDetailsModel> getChronicDiseaseDetails(int id) async {
    final response = await ApiClient.get(
      endpoint: '${AppEndpoints.chronicDiseaseDetails}/$id',
    );

    if (response.data['isSuccess'] == true) {
      return ChronicDiseaseDetailsModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        message:
            response.data['message'] ??
            'Failed to load chronic disease details',
      );
    }
  }

  // ==================== Medical History ====================

  @override
  Future<List<MedicalHistoryModel>> getMedicalHistory() async {
    final response = await ApiClient.get(endpoint: AppEndpoints.medicalHistory);

    if (response.data['isSuccess'] == true) {
      final List<dynamic> list = response.data['data'] ?? [];
      return list.map((item) => MedicalHistoryModel.fromJson(item)).toList();
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load medical history',
      );
    }
  }

  @override
  Future<MedicalHistoryDetailsModel> getMedicalHistoryDetails(int id) async {
    final response = await ApiClient.get(
      endpoint: '${AppEndpoints.medicalHistoryDetails}/$id',
    );

    if (response.data['isSuccess'] == true) {
      return MedicalHistoryDetailsModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        message:
            response.data['message'] ??
            'Failed to load medical history details',
      );
    }
  }

  // ==================== Prescriptions ====================

  @override
  Future<List<PrescriptionModel>> getPrescriptions() async {
    final response = await ApiClient.get(endpoint: AppEndpoints.prescriptions);

    if (response.data['isSuccess'] == true) {
      final List<dynamic> list = response.data['data'] ?? [];
      return list.map((item) => PrescriptionModel.fromJson(item)).toList();
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load prescriptions',
      );
    }
  }

  @override
  Future<PrescriptionDetailsModel> getPrescriptionDetails(int id) async {
    final response = await ApiClient.get(
      endpoint: '${AppEndpoints.prescriptionDetails}/$id',
    );

    if (response.data['isSuccess'] == true) {
      return PrescriptionDetailsModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        message:
            response.data['message'] ?? 'Failed to load prescription details',
      );
    }
  }

  @override
  Future<String> exportPrescription(int prescriptionId) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/prescription_$prescriptionId.pdf';

    final token = AppLocalStorage.getData(StorageKeys.token);

    await Dio().download(
      '${AppEndpoints.baseUrl}${AppEndpoints.prescriptionExport}/$prescriptionId/export',
      filePath,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return filePath;
  }

  // ==================== Lab Results ====================

  @override
  Future<List<LabResultModel>> getLabResults() async {
    final response = await ApiClient.get(endpoint: AppEndpoints.labResults);

    if (response.data['isSuccess'] == true) {
      final List<dynamic> list = response.data['data'] ?? [];
      return list.map((item) => LabResultModel.fromJson(item)).toList();
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load lab results',
      );
    }
  }

  @override
  Future<LabResultDetailsModel> getLabResultDetails(int id) async {
    final response = await ApiClient.get(
      endpoint: AppEndpoints.labResultDetails,
      queryParameters: {'id': id},
    );

    if (response.data['isSuccess'] == true) {
      return LabResultDetailsModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        message:
            response.data['message'] ?? 'Failed to load lab result details',
      );
    }
  }

  @override
  Future<LabAnalysisModel> getLabAnalysis(int id) async {
    final response = await ApiClient.get(
      endpoint: AppEndpoints.labAnalysis,
      queryParameters: {'id': id},
    );

    if (response.data['isSuccess'] == true) {
      return LabAnalysisModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load analysis',
      );
    }
  }

  @override
  Future<String> exportLabResult(int labResultId) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/lab_result_$labResultId.pdf';

    final token = AppLocalStorage.getData(StorageKeys.token);

    await Dio().download(
      '${AppEndpoints.baseUrl}${AppEndpoints.labExportPdf}/$labResultId/exportLabPDF',
      filePath,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return filePath;
  }

  // ==================== Radiology ====================

  @override
  Future<List<RadiologyModel>> getRadiology() async {
    final response = await ApiClient.get(endpoint: AppEndpoints.radiology);

    if (response.data['isSuccess'] == true) {
      final List<dynamic> list = response.data['data'] ?? [];
      return list.map((item) => RadiologyModel.fromJson(item)).toList();
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load radiology',
      );
    }
  }

  @override
  Future<RadiologyDetailsModel> getRadiologyDetails(int id) async {
    final response = await ApiClient.get(
      endpoint: '${AppEndpoints.radiologyDetails}/$id',
    );

    if (response.data['isSuccess'] == true) {
      return RadiologyDetailsModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        message: response.data['message'] ?? 'Failed to load radiology details',
      );
    }
  }

  @override
  Future<String> exportRadiology(int id) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/radiology_$id.pdf';

    final token = AppLocalStorage.getData(StorageKeys.token);

    await Dio().download(
      '${AppEndpoints.baseUrl}${AppEndpoints.radiologyExport}/$id',
      filePath,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return filePath;
  }
}

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

enum RequestStatus { initial, loading, success, error, loadingMore }

class MedicalRecordsState {
  // ==================== Visits ====================
  final RequestStatus visitsStatus;
  final List<VisitModel> visits;
  final String visitsError;
  final int visitsCurrentPage;
  final bool visitsHasMore;

  // ==================== Visit Details ====================
  final RequestStatus visitDetailsStatus;
  final VisitDetailsModel? visitDetails;
  final String visitDetailsError;

  // ==================== Allergies ====================
  final RequestStatus allergiesStatus;
  final List<AllergyModel> allergies;
  final String allergiesError;
  final int allergiesCurrentPage;
  final bool allergiesHasMore;

  // ==================== Allergy Details ====================
  final RequestStatus allergyDetailsStatus;
  final AllergyDetailsModel? allergyDetails;
  final String allergyDetailsError;

  // ==================== Chronic Diseases ====================
  final RequestStatus chronicDiseasesStatus;
  final List<ChronicDiseaseModel> chronicDiseases;
  final String chronicDiseasesError;

  // ==================== Chronic Disease Details ====================
  final RequestStatus chronicDiseaseDetailsStatus;
  final ChronicDiseaseDetailsModel? chronicDiseaseDetails;
  final String chronicDiseaseDetailsError;

  // ==================== Medical History ====================
  final RequestStatus medicalHistoryStatus;
  final List<MedicalHistoryModel> medicalHistory;
  final String medicalHistoryError;

  // ==================== Medical History Details ====================
  final RequestStatus medicalHistoryDetailsStatus;
  final MedicalHistoryDetailsModel? medicalHistoryDetails;
  final String medicalHistoryDetailsError;

  // ==================== Prescriptions ====================
  final RequestStatus prescriptionsStatus;
  final List<PrescriptionModel> prescriptions;
  final String prescriptionsError;

  // ==================== Prescription Details ====================
  final RequestStatus prescriptionDetailsStatus;
  final PrescriptionDetailsModel? prescriptionDetails;
  final String prescriptionDetailsError;

  // ==================== Export Prescription ====================
  final RequestStatus exportStatus;
  final String exportFilePath;
  final String exportError;

  // ==================== Lab Results ====================
  final RequestStatus labResultsStatus;
  final List<LabResultModel> labResults;
  final String labResultsError;

  // ==================== Lab Result Details ====================
  final RequestStatus labResultDetailsStatus;
  final LabResultDetailsModel? labResultDetails;
  final String labResultDetailsError;

  // ==================== Lab Analysis ====================
  final RequestStatus labAnalysisStatus;
  final LabAnalysisModel? labAnalysis;
  final String labAnalysisError;

  // ==================== Export Lab Result ====================
  final RequestStatus exportLabStatus;
  final String exportLabFilePath;
  final String exportLabError;

  const MedicalRecordsState({
    this.visitsStatus = RequestStatus.initial,
    this.visits = const [],
    this.visitsError = '',
    this.visitsCurrentPage = 1,
    this.visitsHasMore = true,
    this.visitDetailsStatus = RequestStatus.initial,
    this.visitDetails,
    this.visitDetailsError = '',
    this.allergiesStatus = RequestStatus.initial,
    this.allergies = const [],
    this.allergiesError = '',
    this.allergiesCurrentPage = 1,
    this.allergiesHasMore = true,
    this.allergyDetailsStatus = RequestStatus.initial,
    this.allergyDetails,
    this.allergyDetailsError = '',
    this.chronicDiseasesStatus = RequestStatus.initial,
    this.chronicDiseases = const [],
    this.chronicDiseasesError = '',
    this.chronicDiseaseDetailsStatus = RequestStatus.initial,
    this.chronicDiseaseDetails,
    this.chronicDiseaseDetailsError = '',
    this.medicalHistoryStatus = RequestStatus.initial,
    this.medicalHistory = const [],
    this.medicalHistoryError = '',
    this.medicalHistoryDetailsStatus = RequestStatus.initial,
    this.medicalHistoryDetails,
    this.medicalHistoryDetailsError = '',
    this.prescriptionsStatus = RequestStatus.initial,
    this.prescriptions = const [],
    this.prescriptionsError = '',
    this.prescriptionDetailsStatus = RequestStatus.initial,
    this.prescriptionDetails,
    this.prescriptionDetailsError = '',
    this.exportStatus = RequestStatus.initial,
    this.exportFilePath = '',
    this.exportError = '',
    this.labResultsStatus = RequestStatus.initial,
    this.labResults = const [],
    this.labResultsError = '',
    this.labResultDetailsStatus = RequestStatus.initial,
    this.labResultDetails,
    this.labResultDetailsError = '',
    this.labAnalysisStatus = RequestStatus.initial,
    this.labAnalysis,
    this.labAnalysisError = '',
    this.exportLabStatus = RequestStatus.initial,
    this.exportLabFilePath = '',
    this.exportLabError = '',
  });

  MedicalRecordsState copyWith({
    RequestStatus? visitsStatus,
    List<VisitModel>? visits,
    String? visitsError,
    int? visitsCurrentPage,
    bool? visitsHasMore,
    RequestStatus? visitDetailsStatus,
    VisitDetailsModel? visitDetails,
    String? visitDetailsError,
    RequestStatus? allergiesStatus,
    List<AllergyModel>? allergies,
    String? allergiesError,
    int? allergiesCurrentPage,
    bool? allergiesHasMore,
    RequestStatus? allergyDetailsStatus,
    AllergyDetailsModel? allergyDetails,
    String? allergyDetailsError,
    RequestStatus? chronicDiseasesStatus,
    List<ChronicDiseaseModel>? chronicDiseases,
    String? chronicDiseasesError,
    RequestStatus? chronicDiseaseDetailsStatus,
    ChronicDiseaseDetailsModel? chronicDiseaseDetails,
    String? chronicDiseaseDetailsError,
    RequestStatus? medicalHistoryStatus,
    List<MedicalHistoryModel>? medicalHistory,
    String? medicalHistoryError,
    RequestStatus? medicalHistoryDetailsStatus,
    MedicalHistoryDetailsModel? medicalHistoryDetails,
    String? medicalHistoryDetailsError,
    RequestStatus? prescriptionsStatus,
    List<PrescriptionModel>? prescriptions,
    String? prescriptionsError,
    RequestStatus? prescriptionDetailsStatus,
    PrescriptionDetailsModel? prescriptionDetails,
    String? prescriptionDetailsError,
    RequestStatus? exportStatus,
    String? exportFilePath,
    String? exportError,
    RequestStatus? labResultsStatus,
    List<LabResultModel>? labResults,
    String? labResultsError,
    RequestStatus? labResultDetailsStatus,
    LabResultDetailsModel? labResultDetails,
    String? labResultDetailsError,
    RequestStatus? labAnalysisStatus,
    LabAnalysisModel? labAnalysis,
    String? labAnalysisError,
    RequestStatus? exportLabStatus,
    String? exportLabFilePath,
    String? exportLabError,
  }) {
    return MedicalRecordsState(
      visitsStatus: visitsStatus ?? this.visitsStatus,
      visits: visits ?? this.visits,
      visitsError: visitsError ?? this.visitsError,
      visitsCurrentPage: visitsCurrentPage ?? this.visitsCurrentPage,
      visitsHasMore: visitsHasMore ?? this.visitsHasMore,
      visitDetailsStatus: visitDetailsStatus ?? this.visitDetailsStatus,
      visitDetails: visitDetails ?? this.visitDetails,
      visitDetailsError: visitDetailsError ?? this.visitDetailsError,
      allergiesStatus: allergiesStatus ?? this.allergiesStatus,
      allergies: allergies ?? this.allergies,
      allergiesError: allergiesError ?? this.allergiesError,
      allergiesCurrentPage: allergiesCurrentPage ?? this.allergiesCurrentPage,
      allergiesHasMore: allergiesHasMore ?? this.allergiesHasMore,
      allergyDetailsStatus: allergyDetailsStatus ?? this.allergyDetailsStatus,
      allergyDetails: allergyDetails ?? this.allergyDetails,
      allergyDetailsError: allergyDetailsError ?? this.allergyDetailsError,
      chronicDiseasesStatus:
          chronicDiseasesStatus ?? this.chronicDiseasesStatus,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      chronicDiseasesError: chronicDiseasesError ?? this.chronicDiseasesError,
      chronicDiseaseDetailsStatus:
          chronicDiseaseDetailsStatus ?? this.chronicDiseaseDetailsStatus,
      chronicDiseaseDetails:
          chronicDiseaseDetails ?? this.chronicDiseaseDetails,
      chronicDiseaseDetailsError:
          chronicDiseaseDetailsError ?? this.chronicDiseaseDetailsError,
      medicalHistoryStatus: medicalHistoryStatus ?? this.medicalHistoryStatus,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      medicalHistoryError: medicalHistoryError ?? this.medicalHistoryError,
      medicalHistoryDetailsStatus:
          medicalHistoryDetailsStatus ?? this.medicalHistoryDetailsStatus,
      medicalHistoryDetails:
          medicalHistoryDetails ?? this.medicalHistoryDetails,
      medicalHistoryDetailsError:
          medicalHistoryDetailsError ?? this.medicalHistoryDetailsError,
      prescriptionsStatus: prescriptionsStatus ?? this.prescriptionsStatus,
      prescriptions: prescriptions ?? this.prescriptions,
      prescriptionsError: prescriptionsError ?? this.prescriptionsError,
      prescriptionDetailsStatus:
          prescriptionDetailsStatus ?? this.prescriptionDetailsStatus,
      prescriptionDetails: prescriptionDetails ?? this.prescriptionDetails,
      prescriptionDetailsError:
          prescriptionDetailsError ?? this.prescriptionDetailsError,
      exportStatus: exportStatus ?? this.exportStatus,
      exportFilePath: exportFilePath ?? this.exportFilePath,
      exportError: exportError ?? this.exportError,
      labResultsStatus: labResultsStatus ?? this.labResultsStatus,
      labResults: labResults ?? this.labResults,
      labResultsError: labResultsError ?? this.labResultsError,
      labResultDetailsStatus:
          labResultDetailsStatus ?? this.labResultDetailsStatus,
      labResultDetails: labResultDetails ?? this.labResultDetails,
      labResultDetailsError:
          labResultDetailsError ?? this.labResultDetailsError,
      labAnalysisStatus: labAnalysisStatus ?? this.labAnalysisStatus,
      labAnalysis: labAnalysis ?? this.labAnalysis,
      labAnalysisError: labAnalysisError ?? this.labAnalysisError,
      exportLabStatus: exportLabStatus ?? this.exportLabStatus,
      exportLabFilePath: exportLabFilePath ?? this.exportLabFilePath,
      exportLabError: exportLabError ?? this.exportLabError,
    );
  }
}

abstract class MedicalRecordsEvent {}

// ==================== Visits Events ====================

class GetVisitHistoryEvent extends MedicalRecordsEvent {
  final int pageIndex;
  final int pageSize;
  final String? visitNumber;
  final String? visitStatus;
  final bool isLoadMore;

  GetVisitHistoryEvent({
    this.pageIndex = 1,
    this.pageSize = 10,
    this.visitNumber,
    this.visitStatus,
    this.isLoadMore = false,
  });
}

class GetVisitDetailsEvent extends MedicalRecordsEvent {
  final int visitId;
  GetVisitDetailsEvent({required this.visitId});
}

// ==================== Allergies Events ====================

class GetAllergiesEvent extends MedicalRecordsEvent {
  final int pageIndex;
  final int pageSize;
  final bool isLoadMore;

  GetAllergiesEvent({
    this.pageIndex = 1,
    this.pageSize = 10,
    this.isLoadMore = false,
  });
}

class GetAllergyDetailsEvent extends MedicalRecordsEvent {
  final int id;
  GetAllergyDetailsEvent({required this.id});
}

// ==================== Chronic Diseases Events ====================

class GetChronicDiseasesEvent extends MedicalRecordsEvent {}

class GetChronicDiseaseDetailsEvent extends MedicalRecordsEvent {
  final int id;
  GetChronicDiseaseDetailsEvent({required this.id});
}

// ==================== Medical History Events ====================

class GetMedicalHistoryEvent extends MedicalRecordsEvent {}

class GetMedicalHistoryDetailsEvent extends MedicalRecordsEvent {
  final int id;
  GetMedicalHistoryDetailsEvent({required this.id});
}

// ==================== Prescriptions Events ====================

class GetPrescriptionsEvent extends MedicalRecordsEvent {}

class GetPrescriptionDetailsEvent extends MedicalRecordsEvent {
  final int id;
  GetPrescriptionDetailsEvent({required this.id});
}

class ExportPrescriptionEvent extends MedicalRecordsEvent {
  final int prescriptionId;
  ExportPrescriptionEvent({required this.prescriptionId});
}

// ==================== Lab Results Events ====================

class GetLabResultsEvent extends MedicalRecordsEvent {}

class GetLabResultDetailsEvent extends MedicalRecordsEvent {
  final int id;
  GetLabResultDetailsEvent({required this.id});
}

class GetLabAnalysisEvent extends MedicalRecordsEvent {
  final int id;
  GetLabAnalysisEvent({required this.id});
}

class ExportLabResultEvent extends MedicalRecordsEvent {
  final int labResultId;
  ExportLabResultEvent({required this.labResultId});
}

// ==================== Radiology Events ==================== ← جديد

class GetRadiologyEvent extends MedicalRecordsEvent {}

class GetRadiologyDetailsEvent extends MedicalRecordsEvent {
  final int id;
  GetRadiologyDetailsEvent({required this.id});
}

class ExportRadiologyEvent extends MedicalRecordsEvent {
  final int id;
  ExportRadiologyEvent({required this.id});
}

// ==================== Reset Event ====================

class ResetMedicalRecordsEvent extends MedicalRecordsEvent {}

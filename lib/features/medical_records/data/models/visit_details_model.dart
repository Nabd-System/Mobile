class VisitDetailsModel {
  final int visitId;
  final String visitNumber;
  final DateTime visitDate;
  final String doctorName;
  final String chiefComplaint;
  final String visitType;
  final String visitStatus;
  final List<VisitPrescriptionModel> prescriptions;
  final List<DiagnosisModel> diagnoses;
  final List<VitalSignsModel> vitalSigns;

  VisitDetailsModel({
    required this.visitId,
    required this.visitNumber,
    required this.visitDate,
    required this.doctorName,
    required this.chiefComplaint,
    required this.visitType,
    required this.visitStatus,
    required this.prescriptions,
    required this.diagnoses,
    required this.vitalSigns,
  });

  factory VisitDetailsModel.fromJson(Map<String, dynamic> json) {
    return VisitDetailsModel(
      visitId: json['visitId'] ?? 0,
      visitNumber: json['visitNumber'] ?? '',
      visitDate: DateTime.tryParse(json['visitDate'] ?? '') ?? DateTime.now(),
      doctorName: json['doctorName'] ?? '',
      chiefComplaint: json['chiefComplaint'] ?? '',
      visitType: json['visitType'] ?? '',
      visitStatus: json['visitStatus'] ?? '',
      prescriptions:
          (json['prescriptions'] as List<dynamic>?)
              ?.map((e) => VisitPrescriptionModel.fromJson(e))
              .toList() ??
          [],
      diagnoses:
          (json['diagnoses'] as List<dynamic>?)
              ?.map((e) => DiagnosisModel.fromJson(e))
              .toList() ??
          [],
      vitalSigns:
          (json['vitalSigns'] as List<dynamic>?)
              ?.map((e) => VitalSignsModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// ==================== Nested Models ====================

class VisitPrescriptionModel {
  final int prescriptionId;
  final int visitId;
  final String visitsNumber;
  final DateTime createdAt;
  final String notes;
  final int numberOfItems;

  VisitPrescriptionModel({
    required this.prescriptionId,
    required this.visitId,
    required this.visitsNumber,
    required this.createdAt,
    required this.notes,
    required this.numberOfItems,
  });

  factory VisitPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return VisitPrescriptionModel(
      prescriptionId: json['prescriptionId'] ?? 0,
      visitId: json['visitId'] ?? 0,
      visitsNumber: json['visitsNumber'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      notes: json['notes'] ?? '',
      numberOfItems: json['numberOfItems'] ?? 0,
    );
  }
}

class DiagnosisModel {
  final int diagnosisId;
  final String diagnosisName;
  final String diagnosisCode;

  DiagnosisModel({
    required this.diagnosisId,
    required this.diagnosisName,
    required this.diagnosisCode,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisModel(
      diagnosisId: json['diagnosisId'] ?? 0,
      diagnosisName: json['diagnosisName'] ?? '',
      diagnosisCode: json['diagnosisCode'] ?? '',
    );
  }
}

class VitalSignsModel {
  final int vitalId;
  final DateTime recordedAt;
  final String visitNumber;
  final double temperature;
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final int heartRate;
  final double oxygenSaturation;
  final double weight;
  final double bmi;

  VitalSignsModel({
    required this.vitalId,
    required this.recordedAt,
    required this.visitNumber,
    required this.temperature,
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.heartRate,
    required this.oxygenSaturation,
    required this.weight,
    required this.bmi,
  });

  factory VitalSignsModel.fromJson(Map<String, dynamic> json) {
    return VitalSignsModel(
      vitalId: json['vitalId'] ?? 0,
      recordedAt: DateTime.tryParse(json['recordedAt'] ?? '') ?? DateTime.now(),
      visitNumber: json['visitNumber'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      bloodPressureSystolic: json['bloodPressureSystolic'] ?? 0,
      bloodPressureDiastolic: json['bloodPressureDiastolic'] ?? 0,
      heartRate: json['heartRate'] ?? 0,
      oxygenSaturation: (json['oxygenSaturation'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      bmi: (json['bmi'] ?? 0).toDouble(),
    );
  }

  String get bloodPressure => '$bloodPressureSystolic/$bloodPressureDiastolic';
}

class MedicalHistoryDetailsModel {
  final int id;
  final String condition;
  final String status;
  final String severity;
  final String treatment;
  final String notes;
  final DateTime diagnosisDate;
  final DateTime recordDate;

  MedicalHistoryDetailsModel({
    required this.id,
    required this.condition,
    required this.status,
    required this.severity,
    required this.treatment,
    required this.notes,
    required this.diagnosisDate,
    required this.recordDate,
  });

  factory MedicalHistoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryDetailsModel(
      id: json['id'] ?? 0,
      condition: json['condition'] ?? '',
      status: json['status'] ?? '',
      severity: json['severity'] ?? '',
      treatment: json['treatment'] ?? '',
      notes: json['notes'] ?? '',
      diagnosisDate:
          DateTime.tryParse(json['diagnosisDate'] ?? '') ?? DateTime.now(),
      recordDate: DateTime.tryParse(json['recordDate'] ?? '') ?? DateTime.now(),
    );
  }
}

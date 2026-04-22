class MedicalHistoryModel {
  final int id;
  final String condition;
  final String status;
  final String severity;
  final DateTime diagnosisDate;

  MedicalHistoryModel({
    required this.id,
    required this.condition,
    required this.status,
    required this.severity,
    required this.diagnosisDate,
  });

  factory MedicalHistoryModel.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryModel(
      id: json['id'] ?? 0,
      condition: json['condition'] ?? '',
      status: json['status'] ?? '',
      severity: json['severity'] ?? '',
      diagnosisDate:
          DateTime.tryParse(json['diagnosisDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'condition': condition,
      'status': status,
      'severity': severity,
      'diagnosisDate': diagnosisDate.toIso8601String(),
    };
  }
}

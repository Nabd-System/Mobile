class ChronicDiseaseDetailsModel {
  final int id;
  final String diseaseName;
  final String diseaseCode;
  final String currentStatus;
  final String medications;
  final String notes;
  final DateTime diagnosisDate;
  final DateTime createAt;
  final DateTime lastUpdatedAt;

  ChronicDiseaseDetailsModel({
    required this.id,
    required this.diseaseName,
    required this.diseaseCode,
    required this.currentStatus,
    required this.medications,
    required this.notes,
    required this.diagnosisDate,
    required this.createAt,
    required this.lastUpdatedAt,
  });

  factory ChronicDiseaseDetailsModel.fromJson(Map<String, dynamic> json) {
    return ChronicDiseaseDetailsModel(
      id: json['id'] ?? 0,
      diseaseName: json['diseaseName'] ?? '',
      diseaseCode: json['diseaseCode'] ?? '',
      currentStatus: json['currentStatus'] ?? '',
      medications: json['medications'] ?? '',
      notes: json['notes'] ?? '',
      diagnosisDate:
          DateTime.tryParse(json['diagnosisDate'] ?? '') ?? DateTime.now(),
      createAt: DateTime.tryParse(json['createAt'] ?? '') ?? DateTime.now(),
      lastUpdatedAt:
          DateTime.tryParse(json['lastUpdatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

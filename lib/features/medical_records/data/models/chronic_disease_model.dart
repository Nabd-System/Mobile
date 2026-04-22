class ChronicDiseaseModel {
  final int id;
  final String diseaseName;
  final String diseaseCode;
  final String currentStatus;
  final DateTime diagnosisDate;

  ChronicDiseaseModel({
    required this.id,
    required this.diseaseName,
    required this.diseaseCode,
    required this.currentStatus,
    required this.diagnosisDate,
  });

  factory ChronicDiseaseModel.fromJson(Map<String, dynamic> json) {
    return ChronicDiseaseModel(
      id: json['id'] ?? 0,
      diseaseName: json['diseaseName'] ?? '',
      diseaseCode: json['diseaseCode'] ?? '',
      currentStatus: json['currentStatus'] ?? '',
      diagnosisDate:
          DateTime.tryParse(json['diagnosisDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diseaseName': diseaseName,
      'diseaseCode': diseaseCode,
      'currentStatus': currentStatus,
      'diagnosisDate': diagnosisDate.toIso8601String(),
    };
  }
}

class RadiologyModel {
  final int reportId;
  final String reportNumber;
  final String reportType;
  final String reportStatus;
  final String findingsEn;
  final DateTime reportDate;

  RadiologyModel({
    required this.reportId,
    required this.reportNumber,
    required this.reportType,
    required this.reportStatus,
    required this.findingsEn,
    required this.reportDate,
  });

  factory RadiologyModel.fromJson(Map<String, dynamic> json) {
    return RadiologyModel(
      reportId: json['reportId'] ?? 0,
      reportNumber: json['reportNumber'] ?? '',
      reportType: json['reportType'] ?? '',
      reportStatus: json['reportStatus'] ?? '',
      findingsEn: json['findingsEn'] ?? '',
      reportDate: json['reportDate'] != null
          ? DateTime.parse(json['reportDate'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'reportNumber': reportNumber,
      'reportType': reportType,
      'reportStatus': reportStatus,
      'findingsEn': findingsEn,
      'reportDate': reportDate.toIso8601String(),
    };
  }
}

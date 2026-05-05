import 'package:nabd/features/medical_records/data/models/radiology_image_model.dart';

class RadiologyDetailsModel {
  final int reportId;
  final String reportNumber;
  final String reportType;
  final String reportStatus;
  final String findingsEn;
  final String findingsAr;
  final String recommendationsEn;
  final String recommendationsAr;
  final String differentialDiagnosis;
  final String icdCodes;

  // Nullable scoring fields
  final String? biradsCategory;
  final String? tiradsCategory;
  final String? piRadsScore;
  final String? liRadsCategory;
  final String? lungRadsCategory;
  final String? amendmentReason;

  final DateTime reportDate;
  final DateTime finalizedDate;
  final DateTime verifiedDate;

  final String radiologistName;
  final List<RadiologyImageModel> images;

  // Patient Info
  final String patientFullName;
  final String fileNumber;
  final String? phone;

  RadiologyDetailsModel({
    required this.reportId,
    required this.reportNumber,
    required this.reportType,
    required this.reportStatus,
    required this.findingsEn,
    required this.findingsAr,
    required this.recommendationsEn,
    required this.recommendationsAr,
    required this.differentialDiagnosis,
    required this.icdCodes,
    this.biradsCategory,
    this.tiradsCategory,
    this.piRadsScore,
    this.liRadsCategory,
    this.lungRadsCategory,
    this.amendmentReason,
    required this.reportDate,
    required this.finalizedDate,
    required this.verifiedDate,
    required this.radiologistName,
    required this.images,
    required this.patientFullName,
    required this.fileNumber,
    this.phone,
  });

  factory RadiologyDetailsModel.fromJson(Map<String, dynamic> json) {
    return RadiologyDetailsModel(
      reportId: json['reportId'] ?? 0,
      reportNumber: json['reportNumber'] ?? '',
      reportType: json['reportType'] ?? '',
      reportStatus: json['reportStatus'] ?? '',
      findingsEn: json['findingsEn'] ?? '',
      findingsAr: json['findingsAr'] ?? '',
      recommendationsEn: json['recommendationsEn'] ?? '',
      recommendationsAr: json['recommendationsAr'] ?? '',
      differentialDiagnosis: json['differentialDiagnosis'] ?? '',
      icdCodes: json['icdCodes'] ?? '',
      biradsCategory: json['biradsCategory'],
      tiradsCategory: json['tiradsCategory'],
      piRadsScore: json['piRadsScore'],
      liRadsCategory: json['liRadsCategory'],
      lungRadsCategory: json['lungRadsCategory'],
      amendmentReason: json['amendmentReason'],
      reportDate: json['reportDate'] != null
          ? DateTime.parse(json['reportDate'])
          : DateTime.now(),
      finalizedDate: json['finalizedDate'] != null
          ? DateTime.parse(json['finalizedDate'])
          : DateTime.now(),
      verifiedDate: json['verifiedDate'] != null
          ? DateTime.parse(json['verifiedDate'])
          : DateTime.now(),
      radiologistName: json['radiologistName'] ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => RadiologyImageModel.fromJson(e))
              .toList() ??
          [],
      patientFullName: json['patientFullName'] ?? '',
      fileNumber: json['fileNumber'] ?? '',
      phone: json['phone'],
    );
  }

  // ==================== Helper Getters ====================

  /// بيرجع true لو فيه أي scoring field مش null
  bool get hasScoring =>
      biradsCategory != null ||
      tiradsCategory != null ||
      piRadsScore != null ||
      liRadsCategory != null ||
      lungRadsCategory != null;

  /// بيرجع list من الـ scoring fields اللي مش null بس
  List<Map<String, String>> get scoringFields {
    final fields = <Map<String, String>>[];
    if (biradsCategory != null) {
      fields.add({'label': 'BI-RADS', 'value': biradsCategory!});
    }
    if (tiradsCategory != null) {
      fields.add({'label': 'TI-RADS', 'value': tiradsCategory!});
    }
    if (piRadsScore != null) {
      fields.add({'label': 'PI-RADS', 'value': piRadsScore!});
    }
    if (liRadsCategory != null) {
      fields.add({'label': 'LI-RADS', 'value': liRadsCategory!});
    }
    if (lungRadsCategory != null) {
      fields.add({'label': 'Lung-RADS', 'value': lungRadsCategory!});
    }
    return fields;
  }
}

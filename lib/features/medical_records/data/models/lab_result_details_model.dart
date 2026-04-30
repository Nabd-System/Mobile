class LabResultDetailsModel {
  final String testName;
  final String? resultStatus;
  final String category;
  final DateTime createdAt;
  final String patientFullName;
  final String fileNumber;
  final String? phone;
  final List<LabParamModel> params;

  LabResultDetailsModel({
    required this.testName,
    this.resultStatus,
    required this.category,
    required this.createdAt,
    required this.patientFullName,
    required this.fileNumber,
    this.phone,
    required this.params,
  });

  factory LabResultDetailsModel.fromJson(Map<String, dynamic> json) {
    return LabResultDetailsModel(
      testName: json['test_Name'] ?? '',
      resultStatus: json['result_Status'],
      category: json['category'] ?? '',
      createdAt: DateTime.tryParse(json['created_At'] ?? '') ?? DateTime.now(),
      patientFullName: json['patientFullName'] ?? '',
      fileNumber: json['fileNumber'] ?? '',
      phone: json['phone'],
      params:
          (json['param'] as List<dynamic>?)
              ?.map((e) => LabParamModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class LabParamModel {
  final String paramName;
  final double paramValue;
  final bool isNormal;
  final String abnormalFlag;
  final String abbreviation;
  final double minNormal;
  final double maxNormal;
  final String unit;

  LabParamModel({
    required this.paramName,
    required this.paramValue,
    required this.isNormal,
    required this.abnormalFlag,
    required this.abbreviation,
    required this.minNormal,
    required this.maxNormal,
    required this.unit,
  });

  factory LabParamModel.fromJson(Map<String, dynamic> json) {
    return LabParamModel(
      paramName: json['param_Name'] ?? '',
      paramValue: (json['param_Value'] ?? 0).toDouble(),
      isNormal: json['is_Normal'] ?? true,
      abnormalFlag: json['abnormalFlag'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      minNormal: (json['min_Normal'] ?? 0).toDouble(),
      maxNormal: (json['max_Normal'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }

  String get normalRange => '$minNormal - $maxNormal';
}

class LabAnalysisModel {
  final String summary;
  final String testName;

  LabAnalysisModel({required this.summary, required this.testName});

  factory LabAnalysisModel.fromJson(Map<String, dynamic> json) {
    return LabAnalysisModel(
      summary: json['summary'] ?? '',
      testName: json['test_name'] ?? '',
    );
  }
}

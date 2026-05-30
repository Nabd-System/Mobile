class SkinAnalysisResultModel {
  final String label;
  final String arabicLabel;
  final String description;
  final String scorePercentage;

  const SkinAnalysisResultModel({
    required this.label,
    required this.arabicLabel,
    required this.description,
    required this.scorePercentage,
  });

  factory SkinAnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return SkinAnalysisResultModel(
      label: json['label'] ?? '',
      arabicLabel: json['arabicLabel'] ?? '',
      description: json['description'] ?? '',
      scorePercentage: json['scorePercentage'] ?? '0%',
    );
  }
}

class SkinAnalysisModel {
  final String disclaimer;
  final List<SkinAnalysisResultModel> results;

  const SkinAnalysisModel({
    required this.disclaimer,
    required this.results,
  });

  factory SkinAnalysisModel.fromJson(Map<String, dynamic> json) {
    return SkinAnalysisModel(
      disclaimer: json['disclaimer'] ?? '',
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => SkinAnalysisResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
class LabResultModel {
  final int id;
  final String name;
  final DateTime createdAt;

  LabResultModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory LabResultModel.fromJson(Map<String, dynamic> json) {
    return LabResultModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'createdAt': createdAt.toIso8601String()};
  }
}

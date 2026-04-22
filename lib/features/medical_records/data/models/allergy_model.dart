class AllergyModel {
  final int id;
  final String allergenType;
  final String allergenName;
  final DateTime createAt;

  AllergyModel({
    required this.id,
    required this.allergenType,
    required this.allergenName,
    required this.createAt,
  });

  factory AllergyModel.fromJson(Map<String, dynamic> json) {
    return AllergyModel(
      id: json['id'] ?? 0,
      allergenType: json['allergenType'] ?? '',
      allergenName: json['allergenName'] ?? '',
      createAt: DateTime.tryParse(json['createAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'allergenType': allergenType,
      'allergenName': allergenName,
      'createAt': createAt.toIso8601String(),
    };
  }
}

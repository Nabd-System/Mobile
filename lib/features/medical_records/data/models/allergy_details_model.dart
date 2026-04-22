class AllergyDetailsModel {
  final int id;
  final String allergenType;
  final String allergenName;
  final String severity;
  final DateTime onSetDate;
  final String status;
  final String notes;
  final DateTime createAt;
  final DateTime updateAt;

  AllergyDetailsModel({
    required this.id,
    required this.allergenType,
    required this.allergenName,
    required this.severity,
    required this.onSetDate,
    required this.status,
    required this.notes,
    required this.createAt,
    required this.updateAt,
  });

  factory AllergyDetailsModel.fromJson(Map<String, dynamic> json) {
    return AllergyDetailsModel(
      id: json['id'] ?? 0,
      allergenType: json['allergenType'] ?? '',
      allergenName: json['allergenName'] ?? '',
      severity: json['severity'] ?? '',
      onSetDate: DateTime.tryParse(json['onSetDate'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      createAt: DateTime.tryParse(json['createAt'] ?? '') ?? DateTime.now(),
      updateAt: DateTime.tryParse(json['updateAt'] ?? '') ?? DateTime.now(),
    );
  }
}

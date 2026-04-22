class PrescriptionModel {
  final int prescriptionId;
  final int visitId;
  final String visitsNumber;
  final DateTime createdAt;
  final String notes;
  final int numberOfItems;

  PrescriptionModel({
    required this.prescriptionId,
    required this.visitId,
    required this.visitsNumber,
    required this.createdAt,
    required this.notes,
    required this.numberOfItems,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      prescriptionId: json['prescriptionId'] ?? 0,
      visitId: json['visitId'] ?? 0,
      visitsNumber: json['visitsNumber'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      notes: json['notes'] ?? '',
      numberOfItems: json['numberOfItems'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': prescriptionId,
      'visitId': visitId,
      'visitsNumber': visitsNumber,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
      'numberOfItems': numberOfItems,
    };
  }
}

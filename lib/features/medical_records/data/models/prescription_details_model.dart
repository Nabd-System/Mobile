class PrescriptionDetailsModel {
  final int prescriptionId;
  final int visitId;
  final String visitNumber;
  final String notes;
  final DateTime createdAt;
  final String patientFullName;
  final String fileNumber;
  final String? phone;
  final DateTime visitDate;
  final String doctorName;
  final String chiefComplaint;
  final List<PrescriptionItemModel> items;

  PrescriptionDetailsModel({
    required this.prescriptionId,
    required this.visitId,
    required this.visitNumber,
    required this.notes,
    required this.createdAt,
    required this.patientFullName,
    required this.fileNumber,
    this.phone,
    required this.visitDate,
    required this.doctorName,
    required this.chiefComplaint,
    required this.items,
  });

  factory PrescriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionDetailsModel(
      prescriptionId: json['prescriptionId'] ?? 0,
      visitId: json['visitId'] ?? 0,
      visitNumber: json['visitNumber'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      patientFullName: json['patientFullName'] ?? '',
      fileNumber: json['fileNumber'] ?? '',
      phone: json['phone'],
      visitDate: DateTime.tryParse(json['visitDate'] ?? '') ?? DateTime.now(),
      doctorName: json['doctorName'] ?? '',
      chiefComplaint: json['chiefComplaint'] ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => PrescriptionItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PrescriptionItemModel {
  final int id;
  final int medicineId;
  final String medicationName;
  final String dosage;
  final String frequency;
  final String duration;
  final String instructions;
  final String? notes;

  PrescriptionItemModel({
    required this.id,
    required this.medicineId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    this.notes,
  });

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemModel(
      id: json['id'] ?? 0,
      medicineId: json['medicineId'] ?? 0,
      medicationName: json['medicationName'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      duration: json['duration'] ?? '',
      instructions: json['instructions'] ?? '',
      notes: json['notes'],
    );
  }
}

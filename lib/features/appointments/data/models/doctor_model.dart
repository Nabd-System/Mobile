class DoctorModel {
  final int id;
  final String name;
  final String specialization;
  final int clinicId;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.clinicId,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      clinicId: json['clinicId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'clinicId': clinicId,
    };
  }
}

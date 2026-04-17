class DoctorModel {
  final int id;
  final String name;
  final String? specialization;
  final int? clinicId;

  const DoctorModel({
    required this.id,
    required this.name,
    this.specialization,
    this.clinicId,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'] ?? '',
      specialization: json['specialization'],
      clinicId: json['clinicId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (specialization != null) 'specialization': specialization,
      if (clinicId != null) 'clinicId': clinicId,
    };
  }
}

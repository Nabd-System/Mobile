class ClinicModel {
  final int id;
  final String name;

  const ClinicModel({required this.id, required this.name});

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(id: json['id'], name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

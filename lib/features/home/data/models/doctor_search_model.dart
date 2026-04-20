class DoctorSearchModel {
  final int doctorId;
  final String doctorName;
  final String? specialization;
  final String clinicName;
  final String workingDayWithHours;
  final String imageUrl;

  const DoctorSearchModel({
    required this.doctorId,
    required this.doctorName,
    this.specialization,
    required this.clinicName,
    required this.workingDayWithHours,
    required this.imageUrl,
  });

  factory DoctorSearchModel.fromJson(Map<String, dynamic> json) {
    return DoctorSearchModel(
      doctorId: json['doctorId'] ?? 0,
      doctorName: json['doctorName'] ?? '',
      specialization: json['specialization'],
      clinicName: json['clinicName'] ?? '',
      workingDayWithHours: json['workingDayWtihHours'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  /// أول يوم شغل مختصر (للعرض في الكارد)
  String get shortWorkingDay {
    if (workingDayWithHours.isEmpty) return 'Not available';
    final firstDay = workingDayWithHours.split(',').first.trim();
    return firstDay;
  }

  /// الـ specialization أو fallback
  String get displaySpecialization {
    return specialization ?? 'General';
  }
}

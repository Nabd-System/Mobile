class TimeSlotModel {
  final int doctorId;
  final String doctorName;
  final String specialization;
  final int clinicId;
  final String clinicName;
  final String date;
  final String slotStart;
  final String slotEnd;
  final bool isAvailable;

  const TimeSlotModel({
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.clinicId,
    required this.clinicName,
    required this.date,
    required this.slotStart,
    required this.slotEnd,
    required this.isAvailable,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      doctorId: json['doctorId'] ?? 0,
      doctorName: json['doctorName'] ?? '',
      specialization: json['specialization'] ?? '',
      clinicId: json['clinicId'] ?? 0,
      clinicName: json['clinicName'] ?? '',
      date: json['date'] ?? '',
      slotStart: json['slotStart'] ?? '',
      slotEnd: json['slotEnd'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,
      'clinicId': clinicId,
      'clinicName': clinicName,
      'date': date,
      'slotStart': slotStart,
      'slotEnd': slotEnd,
      'isAvailable': isAvailable,
    };
  }

  // عشان نعرض الوقت بشكل readable
  String get displayTime {
    final start = slotStart.substring(0, 5); // "09:00"
    return start;
  }

  // AM or PM
  String get period {
    final hour = int.tryParse(slotStart.split(':')[0]) ?? 0;
    return hour < 12 ? 'AM' : 'PM';
  }
}

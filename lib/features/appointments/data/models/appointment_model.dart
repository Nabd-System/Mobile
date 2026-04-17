class AppointmentModel {
  final int appointmentId;
  final int doctorId;
  final String doctorName;
  final String clinicName;
  final String appointmentDate;
  final String status;

  const AppointmentModel({
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.clinicName,
    required this.appointmentDate,
    required this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      appointmentId: json['appointmentId'] ?? 0,
      doctorId: json['doctorId'] ?? 0,
      doctorName: json['doctorName'] ?? '',
      clinicName: json['clinicName'] ?? '',
      appointmentDate: json['appointmentDate'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'clinicName': clinicName,
      'appointmentDate': appointmentDate,
      'status': status,
    };
  }

  // Helpers
  bool get isScheduled => status.toLowerCase() == 'scheduled';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get isCompleted => status.toLowerCase() == 'completed';

  // Format Date للعرض
  String get formattedDate {
    try {
      final date = DateTime.parse(appointmentDate);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]}, ${date.year}';
    } catch (e) {
      return appointmentDate;
    }
  }

  // Format Time للعرض
  String get formattedTime {
    try {
      final date = DateTime.parse(appointmentDate);
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return '';
    }
  }
}

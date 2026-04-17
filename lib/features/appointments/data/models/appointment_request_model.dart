class AppointmentRequestModel {
  final int clinicId;
  final int doctorId;
  final String date;
  final String time;
  final String? notes;

  const AppointmentRequestModel({
    required this.clinicId,
    required this.doctorId,
    required this.date,
    required this.time,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'clinicId': clinicId,
      'doctorId': doctorId,
      'date': date,
      'time': time,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}

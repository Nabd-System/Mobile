class AppointmentRequestModel {
  final int doctorId;
  final int clinicId;
  final String appointmentDate; // "2026-04-20T09:10:00"
  final int appointmentType;
  final String? notes;
  final String fileNumber;

  const AppointmentRequestModel({
    required this.doctorId,
    required this.clinicId,
    required this.appointmentDate,
    required this.appointmentType,
    this.notes,
    required this.fileNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'clinicId': clinicId,
      'appointmentDate': appointmentDate,
      'appointmentType': appointmentType,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'fileNumber': fileNumber,
    };
  }
}

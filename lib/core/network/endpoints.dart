class AppEndpoints {
  AppEndpoints._();

  static const String baseUrl = 'https://nabd.runasp.net/api/';

  // ==================== Auth ====================
  static const String login = 'Account/login';
  static const String logout = 'Account/logout';

  // ==================== Patient ====================
  static const String clinics = 'Patient/Clinics';
  static const String doctors = 'Patient/Doctors';
  static const String patientProfile = 'Patient/My/Profile';
  static const String myAppointments = 'Patient/My/Appointments';

  // ==================== Schedule ====================
  static const String availableSlots = 'Schedule/AvaliableSlot';

  // ==================== Appointment ====================
  static const String bookAppointment = 'Appointment/Book';
}

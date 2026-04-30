class AppEndpoints {
  AppEndpoints._();

  static const String baseUrl = 'https://nabd.runasp.net/api/';

  // ==================== Auth ====================
  static const String login = 'Account/login';
  static const String logout = 'Account/logout';
  static const String refreshToken = 'Account/refresh-token';

  // ==================== Patient ====================
  static const String clinics = 'Patient/Clinics';
  static const String doctors = 'Patient/Doctors';
  static const String patientProfile = 'Patient/My/Profile';
  static const String myAppointments = 'Patient/My/Appointments';
  static const String doctorSearch = 'Patient/DocotorSearch';
  static const String upcomingAppointment = 'Patient/UpComingAppointment';

  // ==================== Schedule ====================
  static const String availableSlots = 'Schedule/AvaliableSlot';

  // ==================== Appointment ====================
  static const String bookAppointment = 'Appointment/Book';

  // ==================== AI ====================
  static const String aiChat = 'Ai/chat';

  // ==================== Medical Records ====================
  static const String visitHistory = 'MedicalRecorde/VisitHistory';
  static const String visitDetails = 'MedicalRecorde/Visit';
  static const String allergies = 'MedicalRecorde/Allergies';
  static const String allergyDetails = 'MedicalRecorde/Allergies';
  static const String prescriptions = 'MedicalRecorde/Prescriptions';
  static const String prescriptionDetails = 'MedicalRecorde/Prescriptions';
  static const String prescriptionExport = 'MedicalRecorde';
  static const String chronicDiseases = 'MedicalRecorde/ChronicDiseases';
  static const String chronicDiseaseDetails = 'MedicalRecorde/ChronicDiseases';
  static const String medicalHistory = 'MedicalRecorde/MedicalHistory';
  static const String medicalHistoryDetails = 'MedicalRecorde/MedicalHistory';
  static const String vitalSignsHistory = 'MedicalRecorde/VitalSignsHistory';

  // ==================== Lab Results ====================
  static const String labResults = 'Lab/GetResults';
  static const String labResultDetails = 'Lab/GetResultDetails';
  static const String labAnalysis = 'Lab/GetAnalysis';
  static const String labExportPdf = 'Lab';
}

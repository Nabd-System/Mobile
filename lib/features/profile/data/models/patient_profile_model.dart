class PatientProfileModel {
  final int id;
  final String fullNameEnglish;
  final String fullNameArabic;
  final String userName;
  final String fileNumber;
  final String gender;
  final String nationalId;
  final String email;
  final String? address;
  final String? city;
  final String? country;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? bloodType;
  final String? insuranceType;
  final String? currentMedications;

  const PatientProfileModel({
    required this.id,
    required this.fullNameEnglish,
    required this.fullNameArabic,
    required this.userName,
    required this.fileNumber,
    required this.gender,
    required this.nationalId,
    required this.email,
    this.address,
    this.city,
    this.country,
    this.phoneNumber,
    this.dateOfBirth,
    this.bloodType,
    this.insuranceType,
    this.currentMedications,
  });

  factory PatientProfileModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileModel(
      id: json['id'] ?? 0,
      fullNameEnglish: json['fullNameEnglish'] ?? '',
      fullNameArabic: json['fullNameArabic'] ?? '',
      userName: json['userName'] ?? '',
      fileNumber: json['fileNumber'] ?? '',
      gender: json['gender'] ?? '',
      nationalId: json['nationalId'] ?? '',
      email: json['email'] ?? '',
      address: json['address'],
      city: json['city'],
      country: json['country'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'],
      bloodType: json['bloodType'],
      insuranceType: json['insuranceType'],
      currentMedications: json['currentMedications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullNameEnglish': fullNameEnglish,
      'fullNameArabic': fullNameArabic,
      'userName': userName,
      'fileNumber': fileNumber,
      'gender': gender,
      'nationalId': nationalId,
      'email': email,
      'address': address,
      'city': city,
      'country': country,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'bloodType': bloodType,
      'insuranceType': insuranceType,
      'currentMedications': currentMedications,
    };
  }
}

class LoginResponseModel {
  final bool isAuthenticated;
  final String email;
  final String accessToken;
  final String refreshToken;
  final String userName;
  final String fullNameArabic;
  final String fullNameEnglish;
  final String userType;

  LoginResponseModel({
    required this.isAuthenticated,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.userName,
    required this.fullNameArabic,
    required this.fullNameEnglish,
    required this.userType,
  });

  // من الـ JSON اللي بييجي من الـ API
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      isAuthenticated: json['isAuthenticated'],
      email: json['email'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userName: json['userName'],
      fullNameArabic: json['fullNameArabic'],
      fullNameEnglish: json['fullNameEnglish'],
      userType: json['userType'],
    );
  }
}

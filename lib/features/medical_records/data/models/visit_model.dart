class VisitModel {
  final int visitId;
  final String visitNumber;
  final DateTime visitDate;
  final String visitType;
  final String visitStatus;
  final String doctorName;
  final String chiefComplaint;

  VisitModel({
    required this.visitId,
    required this.visitNumber,
    required this.visitDate,
    required this.visitType,
    required this.visitStatus,
    required this.doctorName,
    required this.chiefComplaint,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      visitId: json['visitId'] ?? 0,
      visitNumber: json['visitNumber'] ?? '',
      visitDate: DateTime.tryParse(json['visitDate'] ?? '') ?? DateTime.now(),
      visitType: json['visitType'] ?? '',
      visitStatus: json['visitStatus'] ?? '',
      doctorName: json['doctorName'] ?? '',
      chiefComplaint: json['chiefComplaint'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visitId': visitId,
      'visitNumber': visitNumber,
      'visitDate': visitDate.toIso8601String(),
      'visitType': visitType,
      'visitStatus': visitStatus,
      'doctorName': doctorName,
      'chiefComplaint': chiefComplaint,
    };
  }
}

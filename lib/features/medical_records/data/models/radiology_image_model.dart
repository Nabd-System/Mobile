class RadiologyImageModel {
  final int imageId;
  final int imageNumber;
  final String filePath;
  final DateTime acquisitionDate;
  final String notes;

  RadiologyImageModel({
    required this.imageId,
    required this.imageNumber,
    required this.filePath,
    required this.acquisitionDate,
    required this.notes,
  });

  factory RadiologyImageModel.fromJson(Map<String, dynamic> json) {
    return RadiologyImageModel(
      imageId: json['imageId'] ?? 0,
      imageNumber: json['imageNumber'] ?? 0,
      filePath: json['filePath'] ?? '',
      acquisitionDate: json['acquisitionDate'] != null
          ? DateTime.parse(json['acquisitionDate'])
          : DateTime.now(),
      notes: json['notes'] ?? '',
    );
  }
}

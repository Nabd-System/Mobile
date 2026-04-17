class TimeSlotModel {
  final String time;
  final bool isAvailable;
  final String period; // AM or PM

  const TimeSlotModel({
    required this.time,
    required this.isAvailable,
    required this.period,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      time: json['time'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      period: json['period'] ?? 'AM',
    );
  }

  Map<String, dynamic> toJson() {
    return {'time': time, 'isAvailable': isAvailable, 'period': period};
  }
}

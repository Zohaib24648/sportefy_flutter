import 'package:equatable/equatable.dart';

class OperatingHourDTO extends Equatable {
  final int id;
  final String facilityId;
  final String? venueId;
  final String openTime;
  final String closeTime;
  final String dayOfWeek;

  const OperatingHourDTO({
    required this.id,
    required this.facilityId,
    this.venueId,
    required this.openTime,
    required this.closeTime,
    required this.dayOfWeek,
  });

  factory OperatingHourDTO.fromJson(Map<String, dynamic> json) {
    return OperatingHourDTO(
      id: json['id'] as int,
      facilityId: json['facilityId'] as String,
      venueId: json['venueId'] as String?,
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facilityId': facilityId,
      'venueId': venueId,
      'openTime': openTime,
      'closeTime': closeTime,
      'dayOfWeek': dayOfWeek,
    };
  }

  @override
  List<Object?> get props => [
    id,
    facilityId,
    venueId,
    openTime,
    closeTime,
    dayOfWeek,
  ];
}

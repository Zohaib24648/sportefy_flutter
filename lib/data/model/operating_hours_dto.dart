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
      id: json['id'] as int? ?? 0,
      facilityId: json['facilityId'] as String? ?? '',
      venueId: json['venueId'] as String?,
      openTime: json['openTime'] as String? ?? '00:00:00',
      closeTime: json['closeTime'] as String? ?? '23:59:59',
      dayOfWeek: json['dayOfWeek'] as String? ?? 'Monday',
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

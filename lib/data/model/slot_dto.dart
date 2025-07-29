import 'package:equatable/equatable.dart';

class SlotDTO extends Equatable {
  final String id;
  final String venueId;
  final DateTime startTime;
  final DateTime endTime;
  final String eventType;
  final String eventId;
  final DateTime? createdAt;

  const SlotDTO({
    required this.id,
    required this.venueId,
    required this.startTime,
    required this.endTime,
    required this.eventType,
    required this.eventId,
    this.createdAt,
  });

  factory SlotDTO.fromJson(Map<String, dynamic> json) {
    return SlotDTO(
      id: json['id']?.toString() ?? '',
      venueId: json['venueId']?.toString() ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      eventType: json['eventType']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venueId': venueId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'eventType': eventType,
      'eventId': eventId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  factory SlotDTO.empty() {
    return SlotDTO(
      id: '',
      venueId: '',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      eventType: '',
      eventId: '',
      createdAt: null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    venueId,
    startTime,
    endTime,
    eventType,
    eventId,
    createdAt,
  ];
}

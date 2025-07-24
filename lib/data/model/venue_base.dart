import 'package:equatable/equatable.dart';

/// Base model for venue
class VenueBase extends Equatable {
  final String id;
  final String facilityId;
  final String name;
  final String phoneNumber;
  final String spaceType;
  final String availability;
  final int basePrice;
  final int capacity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VenueBase({
    required this.id,
    required this.facilityId,
    required this.name,
    required this.phoneNumber,
    required this.spaceType,
    required this.availability,
    required this.basePrice,
    required this.capacity,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facilityId': facilityId,
      'name': name,
      'phoneNumber': phoneNumber,
      'spaceType': spaceType,
      'availability': availability,
      'basePrice': basePrice,
      'capacity': capacity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory VenueBase.fromJson(Map<String, dynamic> json) {
    return VenueBase(
      id: json['id'] as String,
      facilityId: json['facilityId'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      spaceType: json['spaceType'] as String,
      availability: json['availability'] as String,
      basePrice: json['basePrice'] as int,
      capacity: json['capacity'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    facilityId,
    name,
    phoneNumber,
    spaceType,
    availability,
    basePrice,
    capacity,
    createdAt,
    updatedAt,
  ];
}

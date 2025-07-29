import 'package:equatable/equatable.dart';
import 'package:sportefy/data/model/operating_hours_dto.dart';
import 'package:sportefy/data/model/venue_sport_dto.dart';
import 'media_dto.dart';

class VenueDTO extends Equatable {
  final String id;
  final String facilityId;
  final String name;
  final String phoneNumber;
  final String spaceType;
  final String availability;
  final int basePrice;
  final int capacity;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int totalReviews;
  final int rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OperatingHourDTO> operatingHours;
  final List<MediaDTO> media;
  final List<VenueSportDTO> sports;

  const VenueDTO({
    required this.id,
    required this.facilityId,
    required this.name,
    required this.phoneNumber,
    required this.spaceType,
    required this.availability,
    required this.basePrice,
    required this.capacity,
    this.address,
    this.latitude,
    this.longitude,
    required this.totalReviews,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.operatingHours,
    required this.media,
    required this.sports,
  });

  factory VenueDTO.fromJson(Map<String, dynamic> json) {
    return VenueDTO(
      id: json['id'] as String? ?? '',
      facilityId: json['facilityId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      spaceType: json['spaceType'] as String? ?? '',
      availability: json['availability'] as String? ?? '',
      basePrice: json['basePrice'] as int? ?? 0,
      capacity: json['capacity'] as int? ?? 0,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      totalReviews: json['totalReviews'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      operatingHours:
          (json['operatingHours'] as List<dynamic>?)
              ?.map((e) => OperatingHourDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      media:
          (json['media'] as List<dynamic>?)
              ?.map((e) => MediaDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sports:
          (json['sports'] as List<dynamic>?)
              ?.map((e) => VenueSportDTO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

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
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'totalReviews': totalReviews,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'operatingHours': operatingHours.map((e) => e.toJson()).toList(),
      'media': media.map((e) => e.toJson()).toList(),
      'sports': sports.map((e) => e.toJson()).toList(),
    };
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
    address,
    latitude,
    longitude,
    totalReviews,
    rating,
    createdAt,
    updatedAt,
    operatingHours,
    media,
    sports,
  ];
}

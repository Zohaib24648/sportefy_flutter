import 'package:equatable/equatable.dart';
import 'package:sportefy/data/model/media_dto.dart';
import 'operating_hours_dto.dart';

class VenueDTO extends Equatable {
  final String id;
  final String facilityId;
  final String? name;
  final String? phoneNumber;
  final String? spaceType;
  final String? availability;
  final int basePrice;
  final int capacity;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int totalReviews;
  final int rating;
  final List<MediaDTO> media;
  final List<OperatingHourDTO> operatingHours;

  const VenueDTO({
    required this.id,
    required this.facilityId,
    this.name,
    this.phoneNumber,
    this.spaceType,
    this.availability,
    required this.basePrice,
    required this.capacity,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.latitude,
    this.longitude,
    this.totalReviews = 0,
    this.rating = 0,
    this.media = const [],
    this.operatingHours = const [],
  });

  factory VenueDTO.fromJson(Map<String, dynamic> json) {
    return VenueDTO(
      id: json['id'] as String,
      facilityId: json['facility_id'] as String,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      spaceType: json['spaceType'] as String?,
      availability: json['availability'] as String?,
      basePrice: json['base_price'] as int,
      capacity: json['capacity'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      totalReviews: json['total_reviews'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      media: (json['media'] as List? ?? [])
          .map((e) => MediaDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      operatingHours: (json['operatingHours'] as List? ?? [])
          .map((e) => OperatingHourDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facility_id': facilityId,
      'name': name,
      'phoneNumber': phoneNumber,
      'spaceType': spaceType,
      'availability': availability,
      'base_price': basePrice,
      'capacity': capacity,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'total_reviews': totalReviews,
      'rating': rating,
      'media': media.map((e) => e.toJson()).toList(),
      'operatingHours': operatingHours.map((e) => e.toJson()).toList(),
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
    createdAt,
    updatedAt,
    address,
    latitude,
    longitude,
    totalReviews,
    rating,
    media,
    operatingHours,
  ];
}

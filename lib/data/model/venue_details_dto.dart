import 'package:equatable/equatable.dart';
import 'facility_dto.dart';
import 'media_dto.dart';
import 'operating_hours_dto.dart';
import 'slot_dto.dart';
import 'venue_sport_dto.dart';

class VenueDetailsDTO extends Equatable {
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
  final String? address;
  final double? latitude;
  final double? longitude;
  final int totalReviews;
  final int rating;
  final List<OperatingHourDTO> operatingHours;
  final FacilityDTO facility;
  final List<VenueSportDTO> sports;
  final List<MediaDTO> media;
  final List<SlotDTO> slots;

  const VenueDetailsDTO({
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
    this.address,
    this.latitude,
    this.longitude,
    this.totalReviews = 0,
    this.rating = 0,
    this.operatingHours = const [],
    required this.facility,
    required this.sports,
    this.media = const [],
    this.slots = const [],
  });

  factory VenueDetailsDTO.fromJson(Map<String, dynamic> json) {
    return VenueDetailsDTO(
      id: json['id'] ?? '',
      facilityId: json['facilityId'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      spaceType: json['spaceType'] ?? '',
      availability: json['availability'] ?? '',
      basePrice: json['basePrice'] ?? 0,
      capacity: json['capacity'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      address: json['address'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      rating: json['rating'] ?? 0,
      operatingHours: (json['operatingHours'] as List<dynamic>? ?? [])
          .map((e) => OperatingHourDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      facility: FacilityDTO.fromJson(json['facility']),
      sports: (json['sports'] as List<dynamic>? ?? [])
          .map((e) => VenueSportDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      media: (json['media'] as List<dynamic>? ?? [])
          .map((e) => MediaDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      slots: (json['slots'] as List<dynamic>? ?? [])
          .map((e) => SlotDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
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
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'totalReviews': totalReviews,
    'rating': rating,
    'operatingHours': operatingHours.map((e) => e.toJson()).toList(),
    'facility': facility.toJson(),
    'sports': sports.map((e) => e.toJson()).toList(),
    'media': media.map((e) => e.toJson()).toList(),
    'slots': slots.map((e) => e.toJson()).toList(),
  };

  String get primaryImageUrl =>
      media.isNotEmpty ? media.first.mediaLink : (facility.coverUrl ?? '');

  bool get isOpen24Hours => operatingHours.any(
    (hour) => hour.openTime == '00:00:00' && hour.closeTime == '23:59:59',
  );

  double get resolvedRating => rating.toDouble();
  int get reviewCount => totalReviews;
  int get pricePerHour => basePrice;
  String get resolvedAddress => address ?? facility.address ?? '';
  String get description => facility.description ?? '';

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
    operatingHours,
    facility,
    sports,
    media,
    slots,
  ];
}

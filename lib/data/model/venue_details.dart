import 'package:equatable/equatable.dart';

/// Detailed venue model for the specific venue API response
class VenueDetails extends Equatable {
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
  final List<OperatingHour> operatingHours;
  final Facility facility;
  final List<VenueSport> sports;
  final List<Media> media;
  final List<Slot> slots;

  const VenueDetails({
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
    required this.operatingHours,
    required this.facility,
    required this.sports,
    required this.media,
    required this.slots,
  });

  factory VenueDetails.fromJson(Map<String, dynamic> json) {
    return VenueDetails(
      id: json['id']?.toString() ?? '',
      facilityId: json['facilityId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      spaceType: json['spaceType']?.toString() ?? '',
      availability: json['availability']?.toString() ?? '',
      basePrice: json['basePrice'] as int? ?? 0,
      capacity: json['capacity'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      operatingHours:
          (json['operatingHours'] as List<dynamic>?)
              ?.map((hour) => OperatingHour.fromJson(hour))
              .toList() ??
          [],
      facility: json['facility'] != null
          ? Facility.fromJson(json['facility'])
          : Facility.empty(),
      sports:
          (json['sports'] as List<dynamic>?)
              ?.map((sport) => VenueSport.fromJson(sport))
              .toList() ??
          [],
      media:
          (json['media'] as List<dynamic>?)
              ?.map((mediaItem) => Media.fromJson(mediaItem))
              .toList() ??
          [],
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((slot) => Slot.fromJson(slot))
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'operatingHours': operatingHours.map((hour) => hour.toJson()).toList(),
      'facility': facility.toJson(),
      'sports': sports.map((sport) => sport.toJson()).toList(),
      'media': media.map((mediaItem) => mediaItem.toJson()).toList(),
      'slots': slots.map((slot) => slot.toJson()).toList(),
    };
  }

  // Helper methods
  bool get isOpen24Hours {
    return operatingHours.any(
      (hour) => hour.openTime == '00:00:00' && hour.closeTime == '23:59:59',
    );
  }

  String get primaryImageUrl {
    if (media.isNotEmpty) {
      return media.first.url;
    }
    return facility.coverUrl.isNotEmpty ? facility.coverUrl : '';
  }

  double get rating {
    // Placeholder - would come from reviews in a real implementation
    return 4.5;
  }

  int get reviewCount {
    // Placeholder - would come from reviews in a real implementation
    return 1427;
  }

  int get pricePerHour {
    return basePrice;
  }

  String get address {
    return facility.address;
  }

  String get description {
    return facility.description;
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
    operatingHours,
    facility,
    sports,
    media,
    slots,
  ];
}

/// Operating hours model for venues
class OperatingHour extends Equatable {
  final int id;
  final String facilityId;
  final String? venueId;
  final String openTime;
  final String closeTime;
  final String dayOfWeek;

  const OperatingHour({
    required this.id,
    required this.facilityId,
    this.venueId,
    required this.openTime,
    required this.closeTime,
    required this.dayOfWeek,
  });

  factory OperatingHour.fromJson(Map<String, dynamic> json) {
    return OperatingHour(
      id: json['id'] as int? ?? 0,
      facilityId: json['facilityId']?.toString() ?? '',
      venueId: json['venueId']?.toString(),
      openTime: json['openTime']?.toString() ?? '00:00:00',
      closeTime: json['closeTime']?.toString() ?? '23:59:59',
      dayOfWeek: json['dayOfWeek']?.toString() ?? 'Monday',
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

/// Facility model within venue details
class Facility extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String phoneNumber;
  final String coverUrl;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Facility({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.phoneNumber,
    required this.coverUrl,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id']?.toString() ?? '',
      ownerId: json['ownerId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      coverUrl: json['coverUrl']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  factory Facility.empty() {
    return Facility(
      id: '',
      ownerId: '',
      name: '',
      description: '',
      phoneNumber: '',
      coverUrl: '',
      address: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'phoneNumber': phoneNumber,
      'coverUrl': coverUrl,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    ownerId,
    name,
    description,
    phoneNumber,
    coverUrl,
    address,
    createdAt,
    updatedAt,
  ];
}

/// Venue sport model
class VenueSport extends Equatable {
  final String venueId;
  final String sportId;
  final Sport sport;

  const VenueSport({
    required this.venueId,
    required this.sportId,
    required this.sport,
  });

  factory VenueSport.fromJson(Map<String, dynamic> json) {
    return VenueSport(
      venueId: json['venueId']?.toString() ?? '',
      sportId: json['sportId']?.toString() ?? '',
      sport: json['sport'] != null
          ? Sport.fromJson(json['sport'])
          : Sport.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'venueId': venueId, 'sportId': sportId, 'sport': sport.toJson()};
  }

  @override
  List<Object?> get props => [venueId, sportId, sport];
}

/// Sport model
class Sport extends Equatable {
  final String id;
  final String name;
  final bool timeBound;
  final String? sportType;

  const Sport({
    required this.id,
    required this.name,
    required this.timeBound,
    this.sportType,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      timeBound: json['timeBound'] as bool? ?? false,
      sportType: json['sportType']?.toString(),
    );
  }

  factory Sport.empty() {
    return const Sport(id: '', name: '', timeBound: false, sportType: null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'timeBound': timeBound,
      'sportType': sportType,
    };
  }

  @override
  List<Object?> get props => [id, name, timeBound, sportType];
}

/// Media model
class Media extends Equatable {
  final String id;
  final String url;
  final String type;

  const Media({required this.id, required this.url, required this.type});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'type': type};
  }

  @override
  List<Object?> get props => [id, url, type];
}

/// Slot model
class Slot extends Equatable {
  final String id;
  final String venueId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  const Slot({
    required this.id,
    required this.venueId,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id']?.toString() ?? '',
      venueId: json['venueId']?.toString() ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : DateTime.now(),
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venueId': venueId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }

  @override
  List<Object?> get props => [id, venueId, startTime, endTime, isAvailable];
}

import 'package:equatable/equatable.dart';

/// Detailed facility model for the specific facility API response
class FacilityDetails extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String phoneNumber;
  final String coverUrl;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OperatingHour> operatingHours;
  final List<Venue> venues;
  final Owner owner;
  final List<Media> media;

  const FacilityDetails({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.phoneNumber,
    required this.coverUrl,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.operatingHours,
    required this.venues,
    required this.owner,
    required this.media,
  });

  factory FacilityDetails.fromJson(Map<String, dynamic> json) {
    return FacilityDetails(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      phoneNumber: json['phoneNumber'] as String,
      coverUrl: json['coverUrl'] as String,
      address: json['address'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      operatingHours: (json['operatingHours'] as List<dynamic>)
          .map((hour) => OperatingHour.fromJson(hour))
          .toList(),
      venues: (json['venues'] as List<dynamic>)
          .map((venue) => Venue.fromJson(venue))
          .toList(),
      owner: Owner.fromJson(json['owner']),
      media: (json['media'] as List<dynamic>)
          .map((mediaItem) => Media.fromJson(mediaItem))
          .toList(),
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
      'operatingHours': operatingHours.map((hour) => hour.toJson()).toList(),
      'venues': venues.map((venue) => venue.toJson()).toList(),
      'owner': owner.toJson(),
      'media': media.map((mediaItem) => mediaItem.toJson()).toList(),
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
    return coverUrl;
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
    // Placeholder - would come from pricing in a real implementation
    return 1000;
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
    operatingHours,
    venues,
    owner,
    media,
  ];
}

/// Operating hours model
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

/// Venue model
class Venue extends Equatable {
  final String id;
  final String facilityId;
  final String name;
  final String? description;

  const Venue({
    required this.id,
    required this.facilityId,
    required this.name,
    this.description,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as String,
      facilityId: json['facilityId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facilityId': facilityId,
      'name': name,
      'description': description,
    };
  }

  @override
  List<Object?> get props => [id, facilityId, name, description];
}

/// Owner model
class Owner extends Equatable {
  final String id;
  final Profile profile;

  const Owner({required this.id, required this.profile});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] as String,
      profile: Profile.fromJson(json['profile']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'profile': profile.toJson()};
  }

  @override
  List<Object?> get props => [id, profile];
}

/// Profile model
class Profile extends Equatable {
  final String id;
  final String fullName;
  final String role;
  final String? avatarUrl;
  final String email;
  final String? userName;
  final String? gender;
  final int? age;
  final String? address;
  final String? organization;
  final String? phoneNumber;
  final int credits;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.fullName,
    required this.role,
    this.avatarUrl,
    required this.email,
    this.userName,
    this.gender,
    this.age,
    this.address,
    this.organization,
    this.phoneNumber,
    required this.credits,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      email: json['email'] as String,
      userName: json['userName'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      address: json['address'] as String?,
      organization: json['organization'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      credits: json['credits'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'role': role,
      'avatarUrl': avatarUrl,
      'email': email,
      'userName': userName,
      'gender': gender,
      'age': age,
      'address': address,
      'organization': organization,
      'phoneNumber': phoneNumber,
      'credits': credits,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    role,
    avatarUrl,
    email,
    userName,
    gender,
    age,
    address,
    organization,
    phoneNumber,
    credits,
    createdAt,
    updatedAt,
  ];
}

/// Media model
class Media extends Equatable {
  final String id;
  final String facilityId;
  final String url;
  final String type;

  const Media({
    required this.id,
    required this.facilityId,
    required this.url,
    required this.type,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] as String,
      facilityId: json['facilityId'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'facilityId': facilityId, 'url': url, 'type': type};
  }

  @override
  List<Object?> get props => [id, facilityId, url, type];
}

// import 'package:equatable/equatable.dart';

// /// Detailed facility model for the specific facility API response
// class FacilityDetails extends Equatable {
//   final String id;
//   final String ownerId;
//   final String name;
//   final String description;
//   final String phoneNumber;
//   final String coverUrl;
//   final String address;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final List<OperatingHour> operatingHours;
//   final List<Venue> venues;
//   final Owner owner;
//   final List<Media> media;

//   const FacilityDetails({
//     required this.id,
//     required this.ownerId,
//     required this.name,
//     required this.description,
//     required this.phoneNumber,
//     required this.coverUrl,
//     required this.address,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.operatingHours,
//     required this.venues,
//     required this.owner,
//     required this.media,
//   });

//   factory FacilityDetails.fromJson(Map<String, dynamic> json) {
//     return FacilityDetails(
//       id: json['id'] as String,
//       ownerId: json['ownerId'] as String,
//       name: json['name'] as String,
//       description: json['description'] as String,
//       phoneNumber: json['phoneNumber'] as String,
//       coverUrl: json['coverUrl'] as String,
//       address: json['address'] as String,
//       createdAt: DateTime.parse(json['createdAt'] as String),
//       updatedAt: DateTime.parse(json['updatedAt'] as String),
//       operatingHours: (json['operatingHours'] as List<dynamic>)
//           .map((hour) => OperatingHour.fromJson(hour))
//           .toList(),
//       venues: (json['venues'] as List<dynamic>)
//           .map((venue) => Venue.fromJson(venue))
//           .toList(),
//       owner: Owner.fromJson(json['owner']),
//       media: (json['media'] as List<dynamic>)
//           .map((mediaItem) => Media.fromJson(mediaItem))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'ownerId': ownerId,
//       'name': name,
//       'description': description,
//       'phoneNumber': phoneNumber,
//       'coverUrl': coverUrl,
//       'address': address,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       'operatingHours': operatingHours.map((hour) => hour.toJson()).toList(),
//       'venues': venues.map((venue) => venue.toJson()).toList(),
//       'owner': owner.toJson(),
//       'media': media.map((mediaItem) => mediaItem.toJson()).toList(),
//     };
//   }

//   // Helper methods
//   bool get isOpen24Hours {
//     return operatingHours.any(
//       (hour) => hour.openTime == '00:00:00' && hour.closeTime == '23:59:59',
//     );
//   }

//   String get primaryImageUrl {
//     if (media.isNotEmpty) {
//       return media.first.url;
//     }
//     return coverUrl;
//   }

//   double get rating {
//     // Placeholder - would come from reviews in a real implementation
//     return 4.5;
//   }

//   int get reviewCount {
//     // Placeholder - would come from reviews in a real implementation
//     return 1427;
//   }

//   int get pricePerHour {
//     // Placeholder - would come from pricing in a real implementation
//     return 1000;
//   }

//   @override
//   List<Object?> get props => [
//     id,
//     ownerId,
//     name,
//     description,
//     phoneNumber,
//     coverUrl,
//     address,
//     createdAt,
//     updatedAt,
//     operatingHours,
//     venues,
//     owner,
//     media,
//   ];
// }

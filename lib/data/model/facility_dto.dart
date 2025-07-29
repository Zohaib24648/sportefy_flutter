import 'package:equatable/equatable.dart';

class FacilityDTO extends Equatable {
  final String id;
  final String? ownerId;
  final String? name;
  final String? description;
  final String? phoneNumber;
  final String? coverUrl;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FacilityDTO({
    required this.id,
    this.ownerId,
    this.name,
    this.description,
    this.phoneNumber,
    this.coverUrl,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory FacilityDTO.fromJson(Map<String, dynamic> json) {
    return FacilityDTO(
      id: json['id']?.toString() ?? '',
      ownerId: json['owner_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      phoneNumber: json['phone_number'] as String?,
      coverUrl: json['cover_url'] as String?,
      address: json['address'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (address != null) 'address': address,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
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

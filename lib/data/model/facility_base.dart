import 'package:equatable/equatable.dart';

/// Base model for facility
class FacilityBase extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String phoneNumber;
  final String coverUrl;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FacilityBase({
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

  FacilityBase copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    String? phoneNumber,
    String? coverUrl,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FacilityBase(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      coverUrl: coverUrl ?? this.coverUrl,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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

  factory FacilityBase.fromJson(Map<String, dynamic> json) {
    return FacilityBase(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      phoneNumber: json['phoneNumber'] as String,
      coverUrl: json['coverUrl'] as String,
      address: json['address'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
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

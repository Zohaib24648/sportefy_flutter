import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:sportefy/data/model/common/pagination_dto.dart';
import 'venue_dto.dart';

/// Root level envelope that mirrors the API payload
class VenueListResponseDTO extends Equatable {
  final List<VenueDTO> data;
  final PaginationDTO pagination;

  const VenueListResponseDTO({required this.data, required this.pagination});

  factory VenueListResponseDTO.fromJson(Map<String, dynamic> json) {
    return VenueListResponseDTO(
      data: (json['data'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => VenueDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationDTO.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  @override
  List<Object?> get props => [data, pagination];
}

/// Simple helper that transforms a raw JSON string into the typed envelope
VenueListResponseDTO parseVenueListResponse(String rawJson) {
  final Map<String, dynamic> decoded =
      jsonDecode(rawJson) as Map<String, dynamic>;
  return VenueListResponseDTO.fromJson(decoded);
}

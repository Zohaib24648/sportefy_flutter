import 'package:equatable/equatable.dart';
import 'sport_dto.dart';

/// Venue sport mapping model that matches the API response structure
class VenueSportDTO extends Equatable {
  final String venueId;
  final String sportId;
  final SportDTO sport;

  const VenueSportDTO({
    required this.venueId,
    required this.sportId,
    required this.sport,
  });

  factory VenueSportDTO.fromJson(Map<String, dynamic> json) {
    return VenueSportDTO(
      venueId: json['venueId'] as String? ?? '',
      sportId: json['sportId'] as String? ?? '',
      sport: json['sport'] != null
          ? SportDTO.fromJson(json['sport'] as Map<String, dynamic>)
          : const SportDTO(id: '', name: '', timeBound: false, sportType: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {'venueId': venueId, 'sportId': sportId, 'sport': sport.toJson()};
  }

  @override
  List<Object?> get props => [venueId, sportId, sport];
}

import 'package:sportefy/data/model/venue_details_dto.dart';
import 'package:sportefy/data/model/venue_list_response_dto.dart';

/// Interface for venue repository operations
abstract class IVenueRepository {
  /// Get paginated venues response
  Future<VenueListResponseDTO> getVenuesPaginated({int? page, int? limit});

  /// Get venue by ID
  Future<VenueDetailsDTO> getVenueById(String id);
}

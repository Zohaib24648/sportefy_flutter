import 'package:sportefy/data/model/venue_base_dto.dart';
import 'package:sportefy/data/model/venue_details_dto.dart';

/// Interface for venue repository operations
abstract class IVenueRepository {
  /// Get list of venues
  Future<List<VenueDTO>> getVenues();

  /// Get venue by ID
  Future<VenueDetailsDTO> getVenueById(String id);

  /// Get detailed venue information by ID
  Future<VenueDetailsDTO> getVenueDetails(String id);
}

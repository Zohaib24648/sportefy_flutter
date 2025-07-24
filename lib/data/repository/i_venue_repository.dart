import 'package:sportefy/data/model/venue_base.dart';
import 'package:sportefy/data/model/venue_details.dart';

/// Interface for venue repository operations
abstract class IVenueRepository {
  /// Get list of venues
  Future<List<VenueBase>> getVenues();

  /// Get venue by ID
  Future<VenueBase> getVenueById(String id);

  /// Get detailed venue information by ID
  Future<VenueDetails> getVenueDetails(String id);
}

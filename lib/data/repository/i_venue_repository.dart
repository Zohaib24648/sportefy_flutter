import 'package:sportefy/data/model/venue_base.dart';

/// Interface for venue repository operations
abstract class IVenueRepository {
  /// Get list of venues
  Future<List<VenueBase>> getVenues();
}

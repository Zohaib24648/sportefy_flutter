import 'package:sportefy/data/model/facility_base.dart';

/// Interface for facility repository operations
abstract class IFacilityRepository {
  /// Get list of facilities
  Future<List<FacilityBase>> getFacilities();

  /// Get facility by ID
  Future<FacilityBase> getFacilityById(String id);

  /// Create a new facility
  Future<FacilityBase> createFacility(FacilityBase facility);

  /// Update an existing facility
  Future<FacilityBase> updateFacility(String id, FacilityBase facility);

  /// Delete a facility
  Future<void> deleteFacility(String id);
}

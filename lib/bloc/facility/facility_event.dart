part of 'facility_bloc.dart';

abstract class FacilityEvent {}

class GetFacility extends FacilityEvent {
  final String userId;

  GetFacility(this.userId);
}

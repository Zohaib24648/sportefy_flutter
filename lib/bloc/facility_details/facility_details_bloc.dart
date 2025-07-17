import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/facility_details.dart';
import 'package:sportefy/data/repository/i_facility_repository.dart';

part 'facility_details_event.dart';
part 'facility_details_state.dart';

@injectable
class FacilityDetailsBloc
    extends Bloc<FacilityDetailsEvent, FacilityDetailsState> {
  final IFacilityRepository _facilityRepository;

  FacilityDetailsBloc(this._facilityRepository)
    : super(FacilityDetailsInitial()) {
    on<LoadFacilityDetails>(_onLoadFacilityDetails);
  }

  Future<void> _onLoadFacilityDetails(
    LoadFacilityDetails event,
    Emitter<FacilityDetailsState> emit,
  ) async {
    emit(FacilityDetailsLoading());

    try {
      final facility = await _facilityRepository.getFacilityDetails(
        event.facilityId,
      );
      emit(FacilityDetailsLoaded(facility));
    } catch (e) {
      emit(
        FacilityDetailsError(
          'Failed to load facility details: ${e.toString()}',
        ),
      );
    }
  }
}

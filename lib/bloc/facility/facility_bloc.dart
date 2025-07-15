import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/facility_base.dart';
import 'package:sportefy/data/repository/i_facility_repository.dart';


part 'facility_event.dart';
part 'facility_state.dart';

@injectable
class FacilityBloc extends Bloc<FacilityEvent, FacilityState> {
  final IFacilityRepository _facilityRepository;

  FacilityBloc(this._facilityRepository) : super(FacilityInitial()) {
    on<GetFacility>(_onGetFacility);
  }

  Future<void> _onGetFacility(
    GetFacility event,
    Emitter<FacilityState> emit,
  ) async {
    emit(FacilityLoading());

    try {
      final facilityItems = await _facilityRepository.getFacilities();
      emit(FacilityLoaded(facilityItems));
    } catch (e) {
      emit(FacilityError('Failed to load Facility: ${e.toString()}'));
    }
  }
}

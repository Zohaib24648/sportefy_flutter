import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/venue_base.dart';
import 'package:sportefy/data/repository/i_venue_repository.dart';

part 'facility_event.dart';
part 'facility_state.dart';

@injectable
class FacilityBloc extends Bloc<FacilityEvent, FacilityState> {
  final IVenueRepository _venueRepository;

  FacilityBloc(this._venueRepository) : super(FacilityInitial()) {
    on<GetFacility>(_onGetFacility);
  }

  Future<void> _onGetFacility(
    GetFacility event,
    Emitter<FacilityState> emit,
  ) async {
    emit(FacilityLoading());

    try {
      final venueItems = await _venueRepository.getVenues();
      emit(FacilityLoaded(venueItems));
    } catch (e) {
      emit(FacilityError('Failed to load venues: ${e.toString()}'));
    }
  }
}

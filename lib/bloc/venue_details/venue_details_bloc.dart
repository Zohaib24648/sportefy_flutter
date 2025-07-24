import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/venue_details.dart';
import 'package:sportefy/data/repository/i_venue_repository.dart';

part 'venue_details_event.dart';
part 'venue_details_state.dart';

@injectable
class VenueDetailsBloc extends Bloc<VenueDetailsEvent, VenueDetailsState> {
  final IVenueRepository _venueRepository;

  VenueDetailsBloc(this._venueRepository) : super(VenueDetailsInitial()) {
    on<LoadVenueDetails>(_onLoadVenueDetails);
  }

  Future<void> _onLoadVenueDetails(
    LoadVenueDetails event,
    Emitter<VenueDetailsState> emit,
  ) async {
    emit(VenueDetailsLoading());

    try {
      final venue = await _venueRepository.getVenueDetails(event.venueId);
      emit(VenueDetailsLoaded(venue));
    } catch (e) {
      emit(VenueDetailsError('Failed to load venue details: ${e.toString()}'));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sportefy/data/model/venue_dto.dart';
import 'package:sportefy/data/repository/i_venue_repository.dart';

part 'venue_event.dart';
part 'venue_state.dart';

@injectable
class VenueBloc extends Bloc<VenueEvent, VenueState> {
  final IVenueRepository _venueRepository;

  VenueBloc(this._venueRepository) : super(VenueInitial()) {
    on<GetVenue>(_onGetVenue);
  }

  Future<void> _onGetVenue(GetVenue event, Emitter<VenueState> emit) async {
    emit(VenueLoading());

    try {
      final venueList = await _venueRepository.getVenuesPaginated();
      emit(VenueLoaded(venueList.data));
    } catch (e) {
      emit(VenueError('Failed to load venues: ${e.toString()}'));
    }
  }
}

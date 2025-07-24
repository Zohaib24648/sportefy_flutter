// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
// import 'package:sportefy/data/model/venue.dart';
// import 'package:sportefy/data/repository/i_venue_repository.dart';

// part 'facility_details_event.dart';
// part 'facility_details_state.dart';

// @injectable
// class FacilityDetailsBloc
//     extends Bloc<FacilityDetailsEvent, FacilityDetailsState> {
//   final IVenueRepository _venueRepository;

//   FacilityDetailsBloc(this._venueRepository)
//     : super(FacilityDetailsInitial()) {
//     on<LoadFacilityDetails>(_onLoadFacilityDetails);
//   }

//   Future<void> _onLoadFacilityDetails(
//     LoadFacilityDetails event,
//     Emitter<FacilityDetailsState> emit,
//   ) async {
//     emit(FacilityDetailsLoading());

//     try {
//       // TODO: Implement when venue by ID API is working
//       // final venue = await _venueRepository.getVenueById(
//       //   event.venueId,
//       // );
//       // emit(FacilityDetailsLoaded(venue));
//       emit(FacilityDetailsError('Venue details API not yet implemented'));
//     } catch (e) {
//       emit(
//         FacilityDetailsError(
//           'Failed to load venue details: ${e.toString()}',
//         ),
//       );
//     }
//   }
// }

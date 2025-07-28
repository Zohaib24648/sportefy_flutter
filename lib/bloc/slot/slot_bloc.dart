import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/model/slot.dart';
import '../../data/repository/i_slot_repository.dart';

part 'slot_event.dart';
part 'slot_state.dart';

@injectable
class SlotBloc extends Bloc<SlotEvent, SlotState> {
  final ISlotRepository _slotRepository;

  SlotBloc(this._slotRepository) : super(SlotInitial()) {
    on<LoadVenueSlots>(_onLoadVenueSlots);
    on<RefreshSlots>(_onRefreshSlots);
  }

  Future<void> _onLoadVenueSlots(
    LoadVenueSlots event,
    Emitter<SlotState> emit,
  ) async {
    emit(SlotLoading());
    await _loadSlots(event.venueId, event.date, emit);
  }

  Future<void> _onRefreshSlots(
    RefreshSlots event,
    Emitter<SlotState> emit,
  ) async {
    // Keep current state if loading, otherwise show loading
    if (state is! SlotLoading) {
      emit(SlotLoading());
    }
    await _loadSlots(event.venueId, event.date, emit);
  }

  Future<void> _loadSlots(
    String venueId,
    DateTime date,
    Emitter<SlotState> emit,
  ) async {
    try {
      final response = await _slotRepository.getVenueSlots(
        venueId: venueId,
        date: date,
      );

      if (response.success) {
        final timeSlots = SlotGenerator.generateTimeSlots(date, response.data);
        emit(SlotLoaded(timeSlots: timeSlots, date: date));
      } else {
        emit(SlotError('Failed to load slots: ${response.message}'));
      }
    } catch (e) {
      emit(SlotError('Failed to load slots: ${e.toString()}'));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../data/model/history_item.dart';
import '../../data/repository/i_history_repository.dart';

part 'check_in_event.dart';
part 'check_in_state.dart';

@injectable
class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final IHistoryRepository _historyRepository;

  CheckInBloc(this._historyRepository) : super(CheckInInitial()) {
    on<CheckInRequested>(_onCheckInRequested);
    on<CheckInHistoryRequested>(_onCheckInHistoryRequested);
  }

  Future<void> _onCheckInRequested(
    CheckInRequested event,
    Emitter<CheckInState> emit,
  ) async {
    emit(CheckInLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Parse QR data to determine event info
      final eventName = _parseEventName(event.qrData);

      // Create history item for check-in
      final historyItem = HistoryItemFactory.createCheckInItem(
        id: const Uuid().v4(),
        userId: event.userId,
        eventName: eventName,
        qrData: event.qrData,
        checkInTime: DateTime.now(),
        status: HistoryStatus.success,
      );

      // Save to local database
      await _historyRepository.addHistoryItem(historyItem);

      // Create legacy record for backward compatibility
      final record = CheckInRecord(
        id: historyItem.id,
        userId: event.userId,
        eventName: eventName,
        qrData: event.qrData,
        checkInTime: DateTime.now(),
      );

      emit(
        CheckInSuccess(
          message: 'Successfully checked in to $eventName!',
          record: record,
        ),
      );
    } catch (e) {
      // Create failed check-in history item
      final failedItem = HistoryItemFactory.createCheckInItem(
        id: const Uuid().v4(),
        userId: event.userId,
        eventName: _parseEventName(event.qrData),
        qrData: event.qrData,
        checkInTime: DateTime.now(),
        status: HistoryStatus.failed,
      );

      try {
        await _historyRepository.addHistoryItem(failedItem);
      } catch (dbError) {
        // If we can't save to database, log but don't fail the main operation
        // Debug: Failed to save error to database: $dbError
      }

      emit(CheckInError('Failed to check in: ${e.toString()}'));
    }
  }

  Future<void> _onCheckInHistoryRequested(
    CheckInHistoryRequested event,
    Emitter<CheckInState> emit,
  ) async {
    try {
      // Get check-in history from the new history system
      final historyItems = await _historyRepository.getHistoryByType(
        event.userId,
        HistoryType.checkIn,
      );

      // Convert to legacy CheckInRecord format for backward compatibility
      final userRecords = historyItems.map((historyItem) {
        return CheckInRecord(
          id: historyItem.id,
          userId: historyItem.userId,
          eventName: historyItem.title,
          qrData: historyItem.metadata['qrData'] ?? '',
          checkInTime: historyItem.createdAt,
        );
      }).toList();

      emit(CheckInHistoryLoaded(userRecords));
    } catch (e) {
      emit(CheckInError('Failed to load check-in history: ${e.toString()}'));
    }
  }

  String _parseEventName(String qrData) {
    // Simple QR data parsing - in a real app, this would be more sophisticated
    try {
      // Try to extract event name from QR data
      if (qrData.contains('event:')) {
        return qrData.split('event:')[1].split('|')[0];
      } else if (qrData.contains('sport:')) {
        return qrData.split('sport:')[1].split('|')[0];
      } else {
        // Return a generic event name based on QR data
        return 'Sports Event ${qrData.hashCode.abs() % 100}';
      }
    } catch (e) {
      return 'Unknown Event';
    }
  }
}

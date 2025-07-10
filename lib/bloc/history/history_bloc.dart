import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/model/history_item.dart';
import '../../data/repository/i_history_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

@injectable
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final IHistoryRepository _historyRepository;

  HistoryBloc(this._historyRepository) : super(HistoryInitial()) {
    on<LoadAllHistory>(_onLoadAllHistory);
    on<LoadHistoryByType>(_onLoadHistoryByType);
    on<AddHistoryItem>(_onAddHistoryItem);
    on<UpdateHistoryItem>(_onUpdateHistoryItem);
    on<DeleteHistoryItem>(_onDeleteHistoryItem);
    on<SyncHistory>(_onSyncHistory);
    on<ClearHistory>(_onClearHistory);
  }

  Future<void> _onLoadAllHistory(
    LoadAllHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());

    try {
      final historyItems = await _historyRepository.getAllHistory(event.userId);
      emit(HistoryLoaded(historyItems));
    } catch (e) {
      emit(HistoryError('Failed to load history: ${e.toString()}'));
    }
  }

  Future<void> _onLoadHistoryByType(
    LoadHistoryByType event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());

    try {
      final historyItems = await _historyRepository.getHistoryByType(
        event.userId,
        event.type,
      );
      emit(HistoryLoaded(historyItems));
    } catch (e) {
      emit(HistoryError('Failed to load history: ${e.toString()}'));
    }
  }

  Future<void> _onAddHistoryItem(
    AddHistoryItem event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _historyRepository.addHistoryItem(event.item);

      // Reload history to show updated list
      final historyItems = await _historyRepository.getAllHistory(
        event.item.userId,
      );
      emit(HistoryLoaded(historyItems));
    } catch (e) {
      emit(HistoryError('Failed to add history item: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateHistoryItem(
    UpdateHistoryItem event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _historyRepository.updateHistoryItem(event.item);

      // Reload history to show updated list
      final historyItems = await _historyRepository.getAllHistory(
        event.item.userId,
      );
      emit(HistoryLoaded(historyItems));
    } catch (e) {
      emit(HistoryError('Failed to update history item: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteHistoryItem(
    DeleteHistoryItem event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _historyRepository.deleteHistoryItem(event.itemId);

      // Reload history to show updated list
      final historyItems = await _historyRepository.getAllHistory(event.userId);
      emit(HistoryLoaded(historyItems));
    } catch (e) {
      emit(HistoryError('Failed to delete history item: ${e.toString()}'));
    }
  }

  Future<void> _onSyncHistory(
    SyncHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistorySyncing());

    try {
      await _historyRepository.syncWithServer(event.userId);

      // Reload history to show updated list
      final historyItems = await _historyRepository.getAllHistory(event.userId);
      emit(HistorySyncSuccess(historyItems));
    } catch (e) {
      emit(HistoryError('Failed to sync history: ${e.toString()}'));
    }
  }

  Future<void> _onClearHistory(
    ClearHistory event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _historyRepository.clearLocalHistory(event.userId);
      emit(HistoryLoaded([]));
    } catch (e) {
      emit(HistoryError('Failed to clear history: ${e.toString()}'));
    }
  }
}

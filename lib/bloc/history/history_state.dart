part of 'history_bloc.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryItem> items;

  HistoryLoaded(this.items);
}

class HistorySyncing extends HistoryState {}

class HistorySyncSuccess extends HistoryState {
  final List<HistoryItem> items;

  HistorySyncSuccess(this.items);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}

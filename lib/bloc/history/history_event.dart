part of 'history_bloc.dart';

abstract class HistoryEvent {}

class LoadAllHistory extends HistoryEvent {
  final String userId;

  LoadAllHistory(this.userId);
}

class LoadHistoryByType extends HistoryEvent {
  final String userId;
  final HistoryType type;

  LoadHistoryByType(this.userId, this.type);
}

class AddHistoryItem extends HistoryEvent {
  final HistoryItem item;

  AddHistoryItem(this.item);
}

class UpdateHistoryItem extends HistoryEvent {
  final HistoryItem item;

  UpdateHistoryItem(this.item);
}

class DeleteHistoryItem extends HistoryEvent {
  final String itemId;
  final String userId;

  DeleteHistoryItem(this.itemId, this.userId);
}

class SyncHistory extends HistoryEvent {
  final String userId;

  SyncHistory(this.userId);
}

class ClearHistory extends HistoryEvent {
  final String userId;

  ClearHistory(this.userId);
}

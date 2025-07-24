import '../model/history/history_item.dart';

abstract class IHistoryRepository {
  /// Get all history items for a user
  Future<List<HistoryItem>> getAllHistory(String userId);

  /// Get history items filtered by type
  Future<List<HistoryItem>> getHistoryByType(String userId, HistoryType type);

  /// Get unsynced history items
  Future<List<HistoryItem>> getUnsyncedHistory(String userId);

  /// Add a new history item
  Future<void> addHistoryItem(HistoryItem item);

  /// Update an existing history item
  Future<void> updateHistoryItem(HistoryItem item);

  /// Delete a history item
  Future<void> deleteHistoryItem(String id);

  /// Mark an item as synced
  Future<void> markAsSynced(String id);

  /// Mark all items as synced for a user
  Future<void> markAllAsSynced(String userId);

  /// Sync local history with remote server
  Future<void> syncWithServer(String userId);

  /// Fetch history from server
  Future<List<HistoryItem>> fetchFromServer(String userId);

  /// Clear local history
  Future<void> clearLocalHistory(String userId);
}

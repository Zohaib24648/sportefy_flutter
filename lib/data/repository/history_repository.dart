import 'dart:developer';
import 'package:injectable/injectable.dart';
import '../model/history/history_item.dart';
import 'i_history_repository.dart';

@Injectable(as: IHistoryRepository)
class HistoryRepository implements IHistoryRepository {
  // In-memory storage for demo purposes
  // In a real app, this would call an API service
  final List<HistoryItem> _historyItems = [];

  HistoryRepository();

  @override
  Future<List<HistoryItem>> getAllHistory(String userId) async {
    try {
      return _historyItems.where((item) => item.userId == userId).toList();
    } catch (e) {
      log('Error getting all history: $e');
      return [];
    }
  }

  @override
  Future<List<HistoryItem>> getHistoryByType(
    String userId,
    HistoryType type,
  ) async {
    try {
      return _historyItems
          .where((item) => item.userId == userId && item.type == type)
          .toList();
    } catch (e) {
      log('Error getting history by type: $e');
      return [];
    }
  }

  @override
  Future<List<HistoryItem>> getUnsyncedHistory(String userId) async {
    try {
      // For now, return empty list since we're not tracking sync status locally
      return [];
    } catch (e) {
      log('Error getting unsynced history: $e');
      return [];
    }
  }

  @override
  Future<void> addHistoryItem(HistoryItem item) async {
    try {
      _historyItems.add(item);
      log('History item added successfully: ${item.id}');
    } catch (e) {
      log('Error adding history item: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateHistoryItem(HistoryItem item) async {
    try {
      final index = _historyItems.indexWhere((h) => h.id == item.id);
      if (index != -1) {
        _historyItems[index] = item;
        log('History item updated successfully: ${item.id}');
      }
    } catch (e) {
      log('Error updating history item: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteHistoryItem(String id) async {
    try {
      _historyItems.removeWhere((item) => item.id == id);
      log('History item deleted successfully: $id');
    } catch (e) {
      log('Error deleting history item: $e');
      rethrow;
    }
  }

  @override
  Future<void> markAsSynced(String id) async {
    try {
      // No-op for now since we're not tracking sync status locally
      log('History item marked as synced: $id');
    } catch (e) {
      log('Error marking item as synced: $e');
      rethrow;
    }
  }

  @override
  Future<void> markAllAsSynced(String userId) async {
    try {
      // No-op for now since we're not tracking sync status locally
      log('All history items marked as synced for user: $userId');
    } catch (e) {
      log('Error marking all items as synced: $e');
      rethrow;
    }
  }

  @override
  Future<void> syncWithServer(String userId) async {
    try {
      // 1. Get unsynced items (empty for now)
      final unsyncedItems = await getUnsyncedHistory(userId);

      // 2. Send unsynced items to server
      for (final item in unsyncedItems) {
        await _pushItemToServer(item);
        await markAsSynced(item.id);
      }

      // 3. Fetch latest items from server
      final serverItems = await fetchFromServer(userId);

      // 4. Update local storage with server items
      for (final serverItem in serverItems) {
        final existingItems = await getHistoryByType(userId, serverItem.type);

        final existingItem = existingItems
            .where((item) => item.id == serverItem.id)
            .firstOrNull;

        if (existingItem == null) {
          await addHistoryItem(serverItem);
        } else if (existingItem.updatedAt?.isBefore(
              serverItem.updatedAt ?? DateTime.now(),
            ) ==
            true) {
          await updateHistoryItem(serverItem);
        }
      }

      log('Sync completed successfully for user: $userId');
    } catch (e) {
      log('Error during sync: $e');
      rethrow;
    }
  }

  @override
  Future<List<HistoryItem>> fetchFromServer(String userId) async {
    try {
      // TODO: Implement actual API call
      log('Fetching history from server for user: $userId');

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Return mock data for demo purposes
      return [
        HistoryItem(
          id: 'server-1',
          userId: userId,
          type: HistoryType.checkIn,
          status: HistoryStatus.success,
          title: 'Check-in at Sports Complex',
          description: 'Successfully checked in',
          metadata: {},
          createdAt: DateTime.now().subtract(Duration(days: 1)),
        ),
      ];
    } catch (e) {
      log('Error fetching from server: $e');
      return [];
    }
  }

  @override
  Future<void> clearLocalHistory(String userId) async {
    try {
      _historyItems.removeWhere((item) => item.userId == userId);
      log('Local history cleared for user: $userId');
    } catch (e) {
      log('Error clearing local history: $e');
      rethrow;
    }
  }

  // Helper method to push item to server
  Future<void> _pushItemToServer(HistoryItem item) async {
    try {
      // TODO: Implement actual API call
      log('Pushing item to server: ${item.id}');

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      log('Error pushing item to server: $e');
      rethrow;
    }
  }
}

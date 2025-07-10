import 'dart:convert';
import 'dart:developer';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../db/database.dart';
import '../model/history_item.dart';
import 'i_history_repository.dart';

@Injectable(as: IHistoryRepository)
class HistoryRepository implements IHistoryRepository {
  final AppDatabase _database;

  HistoryRepository(this._database);

  @override
  Future<List<HistoryItem>> getAllHistory(String userId) async {
    try {
      final dbItems = await _database.getAllHistory(userId);
      return dbItems.map(_mapToHistoryItem).toList();
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
      final dbItems = await _database.getHistoryByType(userId, type.value);
      return dbItems.map(_mapToHistoryItem).toList();
    } catch (e) {
      log('Error getting history by type: $e');
      return [];
    }
  }

  @override
  Future<List<HistoryItem>> getUnsyncedHistory(String userId) async {
    try {
      final dbItems = await _database.getUnsyncedHistory(userId);
      return dbItems.map(_mapToHistoryItem).toList();
    } catch (e) {
      log('Error getting unsynced history: $e');
      return [];
    }
  }

  @override
  Future<void> addHistoryItem(HistoryItem item) async {
    try {
      final companion = _mapToCompanion(item);
      await _database.insertHistoryItem(companion);
      log('History item added successfully: ${item.id}');
    } catch (e) {
      log('Error adding history item: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateHistoryItem(HistoryItem item) async {
    try {
      final companion = _mapToCompanion(item);
      await _database.updateHistoryItem(companion);
      log('History item updated successfully: ${item.id}');
    } catch (e) {
      log('Error updating history item: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteHistoryItem(String id) async {
    try {
      await _database.deleteHistoryItem(id);
      log('History item deleted successfully: $id');
    } catch (e) {
      log('Error deleting history item: $e');
      rethrow;
    }
  }

  @override
  Future<void> markAsSynced(String id) async {
    try {
      await _database.markAsSynced(id);
      log('History item marked as synced: $id');
    } catch (e) {
      log('Error marking item as synced: $e');
      rethrow;
    }
  }

  @override
  Future<void> markAllAsSynced(String userId) async {
    try {
      await _database.markAllAsSynced(userId);
      log('All history items marked as synced for user: $userId');
    } catch (e) {
      log('Error marking all items as synced: $e');
      rethrow;
    }
  }

  @override
  Future<void> syncWithServer(String userId) async {
    try {
      // 1. Get unsynced local items
      final unsyncedItems = await getUnsyncedHistory(userId);

      // 2. Push unsynced items to server
      for (final item in unsyncedItems) {
        await _pushItemToServer(item);
        await markAsSynced(item.id);
      }

      // 3. Fetch latest from server
      final serverItems = await fetchFromServer(userId);

      // 4. Update local database with server items
      for (final item in serverItems) {
        final existingItems = await _database.getHistoryByType(
          userId,
          item.type.value,
        );
        final exists = existingItems.any((dbItem) => dbItem.uuid == item.id);

        if (!exists) {
          await addHistoryItem(item.copyWith(isSynced: true));
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
      // For now, return empty list - this would be replaced with actual HTTP calls
      log('Fetching history from server for user: $userId');

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In a real implementation, this would be:
      // final response = await http.get(Uri.parse('$apiUrl/history/$userId'));
      // return (jsonDecode(response.body) as List)
      //     .map((json) => HistoryItem.fromJson(json))
      //     .toList();

      return [];
    } catch (e) {
      log('Error fetching from server: $e');
      return [];
    }
  }

  @override
  Future<void> clearLocalHistory(String userId) async {
    try {
      final allItems = await getAllHistory(userId);
      for (final item in allItems) {
        await deleteHistoryItem(item.id);
      }
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
      // For now, just simulate the call
      log('Pushing item to server: ${item.id}');

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      // In a real implementation, this would be:
      // final response = await http.post(
      //   Uri.parse('$apiUrl/history'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(item.toJson()),
      // );
      //
      // if (response.statusCode != 200) {
      //   throw Exception('Failed to push item to server');
      // }
    } catch (e) {
      log('Error pushing item to server: $e');
      rethrow;
    }
  }

  // Helper method to map database item to HistoryItem
  HistoryItem _mapToHistoryItem(HistoryTableData dbItem) {
    return HistoryItem(
      id: dbItem.uuid,
      userId: dbItem.userId,
      type: HistoryType.fromValue(dbItem.type),
      status: HistoryStatus.fromValue(dbItem.status),
      title: dbItem.title,
      description: dbItem.description,
      metadata: jsonDecode(dbItem.metadata),
      createdAt: dbItem.createdAt,
      updatedAt: dbItem.updatedAt,
      isSynced: dbItem.isSynced,
    );
  }

  // Helper method to map HistoryItem to database companion
  HistoryTableCompanion _mapToCompanion(HistoryItem item) {
    return HistoryTableCompanion(
      uuid: Value(item.id),
      userId: Value(item.userId),
      type: Value(item.type.value),
      status: Value(item.status.value),
      title: Value(item.title),
      description: Value(item.description),
      metadata: Value(jsonEncode(item.metadata)),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      isSynced: Value(item.isSynced),
    );
  }
}

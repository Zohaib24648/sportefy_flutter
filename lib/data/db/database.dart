import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart'; // GENERATED CODE GOES HERE

// Define history table for all types of history items
class HistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().withLength(min: 36, max: 36)();
  TextColumn get userId => text().withLength(min: 1, max: 100)();
  TextColumn get type =>
      text().withLength(min: 1, max: 50)(); // check_in, booking, payment
  TextColumn get status => text().withLength(
    min: 1,
    max: 50,
  )(); // pending, success, failed, cancelled, refunded
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().nullable()();
  TextColumn get metadata => text()(); // JSON string for flexible data storage
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// Connect table(s) to your database class
@DriftDatabase(tables: [HistoryTable])
@injectable
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Version for migrations

  // Tells Drift where to store the database
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'sportefy_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  // History operations
  Future<List<HistoryTableData>> getAllHistory(String userId) {
    return (select(historyTable)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<HistoryTableData>> getHistoryByType(String userId, String type) {
    return (select(historyTable)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.type.equals(type))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<HistoryTableData>> getUnsyncedHistory(String userId) {
    return (select(historyTable)
          ..where(
            (tbl) => tbl.userId.equals(userId) & tbl.isSynced.equals(false),
          )
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<int> insertHistoryItem(HistoryTableCompanion item) {
    return into(historyTable).insert(item);
  }

  Future<bool> updateHistoryItem(HistoryTableCompanion item) {
    return update(historyTable).replace(item);
  }

  Future<int> deleteHistoryItem(String uuid) {
    return (delete(historyTable)..where((tbl) => tbl.uuid.equals(uuid))).go();
  }

  Future<int> markAsSynced(String uuid) {
    return (update(historyTable)..where((tbl) => tbl.uuid.equals(uuid))).write(
      const HistoryTableCompanion(isSynced: Value(true)),
    );
  }

  Future<int> markAllAsSynced(String userId) {
    return (update(historyTable)..where((tbl) => tbl.userId.equals(userId)))
        .write(const HistoryTableCompanion(isSynced: Value(true)));
  }
}

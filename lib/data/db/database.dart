import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart'; // GENERATED CODE GOES HERE

// Define your table
class BookingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().withLength(min: 36 , max: 36)();
  TextColumn get title => text().withLength(min: 1, max: 32)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

// Connect table(s) to your database class
@DriftDatabase(tables: [BookingHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1; // Version for migrations

  // Tells Drift where to store the database
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'sportefy_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}

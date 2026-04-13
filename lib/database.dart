import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'features/beans/data/datasources/beans_table.dart';
import 'features/brew/data/datasources/brew_logs_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [BeansTable, BrewLogsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(
    name: 'coffee_brewing_db',
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
  ));

  @override
  int get schemaVersion => 1;
}
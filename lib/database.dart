import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'features/beans/data/datasources/beans_table.dart';
import 'features/brew/data/datasources/brew_logs_table.dart';
import 'features/recipe/data/datasources/recipe_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [BeansTable, BrewLogsTable, RecipesTable])
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
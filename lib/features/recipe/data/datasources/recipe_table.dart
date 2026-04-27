import 'package:drift/drift.dart';

@DataClassName('RecipesTableData')
class RecipesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get beanId => text().nullable()();
  TextColumn get method => text()();
  RealColumn get dose => real()();
  RealColumn get yieldColumn => real()();
  IntColumn get grindSize => integer()();
  IntColumn get waterTemperature => integer()();
  IntColumn get brewTimeSeconds => integer()();
  IntColumn get rating => integer().nullable()();
  TextColumn get flavorTags => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

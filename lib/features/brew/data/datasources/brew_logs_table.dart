import 'package:drift/drift.dart';

class BrewLogsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get beanId => integer().nullable()();
  TextColumn get method => text()();
  RealColumn get dose => real()();
  RealColumn get yieldColumn => real()();
  IntColumn get grindSize => integer()();
  IntColumn get waterTemperature => integer()();
  IntColumn get brewTimeSeconds => integer()();
  IntColumn get rating => integer().nullable()();
  TextColumn get flavorTags => text().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get tds => real().nullable()();
  RealColumn get extractionYield => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
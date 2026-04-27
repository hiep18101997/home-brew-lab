import 'package:drift/drift.dart';

class BeansTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get roaster => text().withLength(min: 1, max: 100)();
  TextColumn get origin => text().nullable()();
  TextColumn get variety => text().nullable()();
  TextColumn get process => text().nullable()();
  TextColumn get roastLevel => text().nullable()();
  DateTimeColumn get roastDate => dateTime().nullable()();
  RealColumn get weightRemaining => real()();
  RealColumn get weightInitial => real().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
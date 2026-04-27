import '../models/brew_log_dto.dart';
import '../../../../database.dart';

class BrewLogsDriftDataSource {
  final AppDatabase _db;

  BrewLogsDriftDataSource(this._db);

  Future<List<BrewLogDto>> getAllBrewLogs() async {
    final rows = await _db.select(_db.brewLogsTable).get();
    return rows.map((row) => BrewLogDto.fromDrift(row)).toList();
  }

  Future<List<BrewLogDto>> getBrewLogsByBeanId(int beanId) async {
    final rows = await (_db.select(_db.brewLogsTable)
          ..where((t) => t.beanId.equals(beanId)))
        .get();
    return rows.map((row) => BrewLogDto.fromDrift(row)).toList();
  }

  Future<BrewLogDto?> getBrewLogById(int id) async {
    final row = await (_db.select(_db.brewLogsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? BrewLogDto.fromDrift(row) : null;
  }

  Future<BrewLogDto> insertBrewLog(BrewLogsTableCompanion log) async {
    final id = await _db.into(_db.brewLogsTable).insert(log);
    final result = await getBrewLogById(id);
    if (result == null) {
      throw Exception('Failed to insert brew log');
    }
    return result;
  }

  Future<void> deleteBrewLog(int id) async {
    await (_db.delete(_db.brewLogsTable)..where((t) => t.id.equals(id))).go();
  }
}
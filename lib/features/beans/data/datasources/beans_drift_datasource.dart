import '../../../../database.dart';
import '../models/bean_dto.dart';

class BeansDriftDataSource {
  final AppDatabase _db;

  BeansDriftDataSource(this._db);

  Future<List<BeanDto>> getAllBeans() async {
    final rows = await _db.select(_db.beansTable).get();
    return rows.map((row) => BeanDto.fromDrift(row)).toList();
  }

  Future<BeanDto?> getBeanById(int id) async {
    final row = await (_db.select(_db.beansTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? BeanDto.fromDrift(row) : null;
  }

  Future<BeanDto> insertBean(BeansTableCompanion bean) async {
    final id = await _db.into(_db.beansTable).insert(bean);
    final result = await getBeanById(id);
    if (result == null) {
      throw Exception('Failed to insert bean');
    }
    return result;
  }

  Future<void> updateBean(BeansTableCompanion bean) async {
    await (_db.update(_db.beansTable)..where((t) => t.id.equals(bean.id.value)))
        .write(bean);
  }

  Future<void> deleteBean(int id) async {
    await (_db.delete(_db.beansTable)..where((t) => t.id.equals(id))).go();
  }
}
import '../../../../core/constants/brew_methods.dart';
import '../../domain/entities/brew_log.dart';
import '../../domain/repositories/brew_repository.dart';
import '../datasources/brew_logs_drift_datasource.dart';
import '../models/brew_log_dto.dart';

class BrewRepositoryImpl implements BrewRepository {
  final BrewLogsDriftDataSource _dataSource;

  BrewRepositoryImpl(this._dataSource);

  @override
  Future<List<BrewLog>> getAllBrewLogs() async {
    final dtos = await _dataSource.getAllBrewLogs();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<BrewLog>> getBrewLogsByBeanId(String beanId) async {
    final dtos = await _dataSource.getBrewLogsByBeanId(int.parse(beanId));
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<BrewLog>> getBrewLogsByMethod(BrewMethod method) async {
    final allLogs = await getAllBrewLogs();
    return allLogs.where((log) => log.method == method).toList();
  }

  @override
  Future<BrewLog?> getBrewLogById(String id) async {
    final dto = await _dataSource.getBrewLogById(int.parse(id));
    return dto?.toEntity();
  }

  @override
  Future<BrewLog> createBrewLog(BrewLog log) async {
    final companion = BrewLogDto.fromEntity(log);
    final inserted = await _dataSource.insertBrewLog(companion);
    return inserted.toEntity();
  }

  @override
  Future<BrewLog> updateBrewLog(BrewLog log) async {
    return log;
  }

  @override
  Future<void> deleteBrewLog(String id) async {
    await _dataSource.deleteBrewLog(int.parse(id));
  }
}
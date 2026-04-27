import '../../domain/entities/grinder_profile.dart';
import '../../domain/repositories/grinder_repository.dart';
import '../datasources/grinder_static_datasource.dart';

class GrinderRepositoryImpl implements GrinderRepository {
  final GrinderStaticDataSource _dataSource;

  GrinderRepositoryImpl(this._dataSource);

  @override
  Future<List<GrinderProfile>> getAllGrinders() async {
    return _dataSource.getAllGrinders();
  }

  @override
  Future<List<GrinderProfile>> getGrindersByBrand(GrinderBrand brand) async {
    return _dataSource.getGrindersByBrand(brand);
  }

  @override
  Future<GrinderSettings?> getGrinderSettings(
    GrinderBrand brand,
    String model,
    String brewMethod,
  ) async {
    return _dataSource.getGrinderSettings(brand, model, brewMethod);
  }
}

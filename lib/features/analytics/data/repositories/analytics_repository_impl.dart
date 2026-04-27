import '../../domain/entities/analytics_data.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_datasource.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsDataSource _dataSource;

  AnalyticsRepositoryImpl(this._dataSource);

  @override
  Future<AnalyticsData> getAnalytics() async {
    return await _dataSource.getAnalytics();
  }
}

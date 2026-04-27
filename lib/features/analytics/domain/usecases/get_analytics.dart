import '../entities/analytics_data.dart';
import '../repositories/analytics_repository.dart';

class GetAnalytics {
  final AnalyticsRepository repository;

  GetAnalytics(this.repository);

  Future<AnalyticsData> call() async {
    return await repository.getAnalytics();
  }
}

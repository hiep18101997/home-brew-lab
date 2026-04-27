import '../entities/analytics_data.dart';

/// Abstract repository interface for Analytics operations
abstract class AnalyticsRepository {
  /// Get analytics data calculated from Beans and BrewLogs
  Future<AnalyticsData> getAnalytics();
}

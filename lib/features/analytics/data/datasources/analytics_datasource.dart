import '../../../../core/constants/brew_methods.dart';
import '../../../../database.dart';
import '../../domain/entities/analytics_data.dart';
import '../../../beans/data/models/bean_dto.dart';
import '../../../brew/data/models/brew_log_dto.dart';

class AnalyticsDataSource {
  final AppDatabase _db;

  AnalyticsDataSource(this._db);

  Future<AnalyticsData> getAnalytics() async {
    // Fetch all beans and brew logs
    final beanRows = await _db.select(_db.beansTable).get();
    final brewLogRows = await _db.select(_db.brewLogsTable).get();

    final beans = beanRows.map((row) => BeanDto.fromDrift(row)).toList();
    final brewLogs = brewLogRows.map((row) => BrewLogDto.fromDrift(row)).toList();

    if (brewLogs.isEmpty) {
      return AnalyticsData.empty();
    }

    // Total brews
    final totalBrews = brewLogs.length;

    // Average rating
    final ratedLogs = brewLogs.where((b) => b.rating != null).toList();
    final averageRating = ratedLogs.isEmpty
        ? 0.0
        : ratedLogs.map((b) => b.rating!).reduce((a, b) => a + b) / ratedLogs.length;

    // Favorite method
    final methodCounts = <BrewMethod, int>{};
    for (final log in brewLogs) {
      methodCounts[log.method] = (methodCounts[log.method] ?? 0) + 1;
    }
    BrewMethod? favoriteMethod;
    if (methodCounts.isNotEmpty) {
      favoriteMethod = methodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    // Total beans used (based on beans with weight changes)
    final totalBeansUsed = beans.where((b) => b.weightInitial != null && b.weightInitial! > b.weightRemaining).length;

    // Brews per week (last 8 weeks)
    final now = DateTime.now();
    final brewsPerWeek = <int, int>{};
    for (int i = 7; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: now.weekday + (i * 7)));
      final weekNum = _weekNumber(weekStart);
      brewsPerWeek[weekNum] = 0;
    }
    for (final log in brewLogs) {
      final weekNum = _weekNumber(log.createdAt);
      if (brewsPerWeek.containsKey(weekNum)) {
        brewsPerWeek[weekNum] = brewsPerWeek[weekNum]! + 1;
      }
    }

    // Method distribution
    final methodDistribution = methodCounts;

    // Rating trend (last 30 days, daily average)
    final ratingTrend = <RatingDataPoint>[];
    final today = DateTime(now.year, now.month, now.day);
    for (int i = 29; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final dayLogs = brewLogs.where((b) =>
          b.rating != null &&
          b.createdAt.year == day.year &&
          b.createdAt.month == day.month &&
          b.createdAt.day == day.day).toList();
      if (dayLogs.isNotEmpty) {
        final avg = dayLogs.map((b) => b.rating!).reduce((a, b) => a + b) / dayLogs.length;
        ratingTrend.add(RatingDataPoint(date: day, avgRating: avg));
      }
    }

    // Bean usage
    final beanUsageList = <BeanUsage>[];
    final beanBrewCounts = <int, int>{};
    for (final log in brewLogs) {
      if (log.beanId != null) {
        beanBrewCounts[log.beanId!] = (beanBrewCounts[log.beanId!] ?? 0) + 1;
      }
    }
    for (final bean in beans) {
      if (bean.weightInitial == null) continue;
      final brewsCount = beanBrewCounts[bean.id] ?? 0;
      final weightUsed = bean.weightInitial! - bean.weightRemaining;
      final avgWeightPerBrew = brewsCount > 0 ? weightUsed / brewsCount : 0;
      final brewsLeft = avgWeightPerBrew > 0 ? (bean.weightRemaining / avgWeightPerBrew).floor() : 999;
      beanUsageList.add(BeanUsage(
        beanId: bean.id.toString(),
        beanName: bean.name,
        weightRemaining: bean.weightRemaining,
        weightInitial: bean.weightInitial!,
        brewsCount: brewsCount,
        brewsLeft: brewsLeft,
      ));
    }

    return AnalyticsData(
      totalBrews: totalBrews,
      averageRating: averageRating,
      favoriteMethod: favoriteMethod,
      totalBeansUsed: totalBeansUsed,
      brewsPerWeek: brewsPerWeek,
      methodDistribution: methodDistribution,
      ratingTrend: ratingTrend,
      beanUsageList: beanUsageList,
    );
  }

  int _weekNumber(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
}

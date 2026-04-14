import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/brew_log.dart';
import '../../domain/entities/bean.dart';
import '../../core/constants/brew_methods.dart';
import 'beans_provider.dart';
import 'brew_logs_provider.dart';

/// Analytics data model
class AnalyticsData {
  final int totalBrews;
  final double averageRating;
  final BrewMethod? favoriteMethod;
  final int totalBeansUsed;
  final Map<int, int> brewsPerWeek; // weekNumber -> count (last 8 weeks)
  final Map<BrewMethod, int> methodDistribution;
  final List<RatingDataPoint> ratingTrend; // last 30 days
  final List<BeanUsage> beanUsageList;

  const AnalyticsData({
    required this.totalBrews,
    required this.averageRating,
    required this.favoriteMethod,
    required this.totalBeansUsed,
    required this.brewsPerWeek,
    required this.methodDistribution,
    required this.ratingTrend,
    required this.beanUsageList,
  });

  factory AnalyticsData.empty() => const AnalyticsData(
    totalBrews: 0,
    averageRating: 0,
    favoriteMethod: null,
    totalBeansUsed: 0,
    brewsPerWeek: {},
    methodDistribution: {},
    ratingTrend: [],
    beanUsageList: [],
  );
}

class RatingDataPoint {
  final DateTime date;
  final double avgRating;
  const RatingDataPoint(this.date, this.avgRating);
}

class BeanUsage {
  final String beanId;
  final String beanName;
  final double weightRemaining;
  final double weightInitial;
  final int brewsCount;
  final int brewsLeft;
  const BeanUsage({
    required this.beanId,
    required this.beanName,
    required this.weightRemaining,
    required this.weightInitial,
    required this.brewsCount,
    required this.brewsLeft,
  });
}

/// Analytics notifier
class AnalyticsNotifier extends StateNotifier<AnalyticsData> {
  final Ref ref;

  AnalyticsNotifier(this.ref) : super(AnalyticsData.empty()) {
    _calculate();
  }

  void _calculate() {
    final brewLogs = ref.read(brewLogsProvider).valueOrNull ?? [];
    final beans = ref.read(beansProvider).valueOrNull ?? [];

    if (brewLogs.isEmpty) {
      state = AnalyticsData.empty();
      return;
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
        ratingTrend.add(RatingDataPoint(day, avg));
      }
    }

    // Bean usage
    final beanUsageList = <BeanUsage>[];
    final beanBrewCounts = <String, int>{};
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
        beanId: bean.id,
        beanName: bean.name,
        weightRemaining: bean.weightRemaining,
        weightInitial: bean.weightInitial!,
        brewsCount: brewsCount,
        brewsLeft: brewsLeft,
      ));
    }

    state = AnalyticsData(
      totalBrews: totalBrews,
      averageRating: averageRating,
      favoriteMethod: favoriteMethod,
      totalBeansUsed: totalBeansUsed,
      brewsPerWeek: brewsPerWeek,
      methodDistribution: methodCounts,
      ratingTrend: ratingTrend,
      beanUsageList: beanUsageList,
    );
  }

  int _weekNumber(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  void refresh() => _calculate();
}

final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AnalyticsData>((ref) {
  // Listen to brewLogs and beans changes
  ref.watch(brewLogsProvider);
  ref.watch(beansProvider);
  return AnalyticsNotifier(ref);
});

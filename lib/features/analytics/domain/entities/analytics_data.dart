import 'package:equatable/equatable.dart';
import '../../../../core/constants/brew_methods.dart';

/// Analytics data model containing all brew statistics
class AnalyticsData extends Equatable {
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

  @override
  List<Object?> get props => [
    totalBrews,
    averageRating,
    favoriteMethod,
    totalBeansUsed,
    brewsPerWeek,
    methodDistribution,
    ratingTrend,
    beanUsageList,
  ];
}

/// A single data point for rating trend chart
class RatingDataPoint extends Equatable {
  final DateTime date;
  final double avgRating;

  const RatingDataPoint({
    required this.date,
    required this.avgRating,
  });

  @override
  List<Object?> get props => [date, avgRating];
}

/// Bean usage statistics
class BeanUsage extends Equatable {
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

  @override
  List<Object?> get props => [
    beanId,
    beanName,
    weightRemaining,
    weightInitial,
    brewsCount,
    brewsLeft,
  ];
}

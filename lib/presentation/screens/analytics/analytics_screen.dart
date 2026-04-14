import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/analytics_provider.dart';
import '../../../core/constants/brew_methods.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Analytics',
          style: GoogleFonts.notoSerif(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: analytics.totalBrews == 0
          ? _EmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryStatsRow(analytics: analytics),
                  const SizedBox(height: 24),
                  _SectionCard(
                    title: 'Brews This Week',
                    child: SizedBox(
                      height: 200,
                      child: _BrewsPerWeekChart(data: analytics.brewsPerWeek),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Brew Methods',
                    child: SizedBox(
                      height: 200,
                      child: _MethodPieChart(data: analytics.methodDistribution),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (analytics.ratingTrend.isNotEmpty)
                    _SectionCard(
                      title: 'Rating Trend (30 days)',
                      child: SizedBox(
                        height: 200,
                        child: _RatingTrendChart(data: analytics.ratingTrend),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (analytics.beanUsageList.isNotEmpty)
                    _SectionCard(
                      title: 'Bean Usage',
                      child: Column(
                        children: analytics.beanUsageList
                            .take(5)
                            .map((b) => _BeanUsageItem(bean: b))
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_outlined, size: 64, color: AppColors.onSurfaceVariant),
          const SizedBox(height: 16),
          Text('No brew data yet', style: GoogleFonts.notoSerif(fontSize: 20, color: AppColors.onSurface)),
          const SizedBox(height: 8),
          Text('Start logging brews to see your analytics', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _SummaryStatsRow extends StatelessWidget {
  final AnalyticsData analytics;
  const _SummaryStatsRow({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(icon: Icons.coffee, value: '${analytics.totalBrews}', label: 'Total Brews', color: AppColors.secondary)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(icon: Icons.star, value: analytics.averageRating > 0 ? analytics.averageRating.toStringAsFixed(1) : '-', label: 'Avg Rating', color: AppColors.tertiary)),
        const SizedBox(width: 12),
        Expanded(child: _StatCard(icon: Icons.favorite, value: analytics.favoriteMethod?.displayName ?? '-', label: 'Favorite', color: AppColors.primary)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _BrewsPerWeekChart extends StatelessWidget {
  final Map<int, int> data;
  const _BrewsPerWeekChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return Center(child: Text('No data', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)));
    final maxY = data.values.isEmpty ? 10.0 : (data.values.reduce((a, b) => a > b ? a : b) + 2).toDouble();
    final weeks = data.keys.toList()..sort();

    return BarChart(
      BarChartData(
        maxY: maxY,
        barGroups: weeks.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [BarChartRodData(toY: data[weeks[e.key]]!.toDouble(), color: AppColors.secondary, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: GoogleFonts.manrope(fontSize: 10, color: AppColors.onSurfaceVariant)))),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) { final idx = v.toInt(); return idx >= 0 && idx < weeks.length ? Text('W${weeks[idx]}', style: GoogleFonts.manrope(fontSize: 10, color: AppColors.onSurfaceVariant)) : const SizedBox(); })),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.surfaceContainerHigh, strokeWidth: 1)),
      ),
    );
  }
}

class _MethodPieChart extends StatelessWidget {
  final Map<BrewMethod, int> data;
  const _MethodPieChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return Center(child: Text('No data', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)));
    final colors = [AppColors.secondary, AppColors.primary, AppColors.tertiary, AppColors.secondary.withOpacity(0.7), AppColors.primary.withOpacity(0.7), AppColors.tertiary.withOpacity(0.7)];
    final total = data.values.fold(0, (a, b) => a + b);
    final entries = data.entries.toList();

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: entries.asMap().entries.map((e) {
                final pct = (e.value.value / total * 100).toStringAsFixed(0);
                return PieChartSectionData(value: e.value.value.toDouble(), title: '$pct%', color: colors[e.key % colors.length], radius: 60, titleStyle: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white));
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: entries.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: colors[e.key % colors.length], shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(e.value.key.displayName, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurface)),
              ]),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RatingTrendChart extends StatelessWidget {
  final List<RatingDataPoint> data;
  const _RatingTrendChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return Center(child: Text('No data', style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)));

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 5,
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.avgRating)).toList(),
            isCurved: true,
            color: AppColors.tertiary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: AppColors.tertiary.withOpacity(0.2)),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 1, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: GoogleFonts.manrope(fontSize: 10, color: AppColors.onSurfaceVariant)))),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false, horizontalInterval: 1, getDrawingHorizontalLine: (v) => FlLine(color: AppColors.surfaceContainerHigh, strokeWidth: 1)),
      ),
    );
  }
}

class _BeanUsageItem extends StatelessWidget {
  final BeanUsage bean;
  const _BeanUsageItem({required this.bean});

  @override
  Widget build(BuildContext context) {
    final percentUsed = bean.weightInitial > 0 ? ((bean.weightInitial - bean.weightRemaining) / bean.weightInitial * 100) : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(bean.beanName, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface), overflow: TextOverflow.ellipsis)),
              Text('${bean.brewsLeft} brews left', style: GoogleFonts.manrope(fontSize: 12, color: bean.brewsLeft < 5 ? AppColors.error : AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(3)),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (percentUsed / 100).clamp(0.0, 1.0),
                    child: Container(decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(3))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${bean.weightRemaining.toStringAsFixed(0)}g', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

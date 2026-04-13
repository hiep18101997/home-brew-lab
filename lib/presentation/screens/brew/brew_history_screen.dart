import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/brew_logs_provider.dart';
import '../../../core/constants/brew_methods.dart';
import '../../../domain/entities/brew_log.dart';

class BrewHistoryScreen extends ConsumerWidget {
  const BrewHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brewLogsAsync = ref.watch(brewLogsProvider);
    final filter = ref.watch(brewLogsFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Brew History',
          style: GoogleFonts.notoSerif(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Filter chips - scrollable horizontal
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: filter == null,
                  selectedColor: AppColors.secondary,
                  backgroundColor: AppColors.surfaceContainerLow,
                  textColor: AppColors.onSurface,
                  onTap: () {
                    ref.read(brewLogsFilterProvider.notifier).state = null;
                  },
                ),
                const SizedBox(width: 8),
                ...BrewMethod.values.map((method) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    label: method.displayName,
                    isSelected: filter == method,
                    selectedColor: AppColors.secondary,
                    backgroundColor: AppColors.surfaceContainerLow,
                    textColor: AppColors.onSurface,
                    onTap: () {
                      ref.read(brewLogsFilterProvider.notifier).state = method;
                    },
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Brew logs list
          Expanded(
            child: brewLogsAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.secondary),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Error: $e',
                  style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
                ),
              ),
              data: (logs) {
                final filteredLogs = filter != null
                    ? logs.where((l) => l.method == filter).toList()
                    : logs;

                if (filteredLogs.isEmpty) {
                  return _EmptyState(
                    surfaceColor: AppColors.surfaceContainerLow,
                    iconColor: AppColors.onSurfaceVariant,
                    textColor: AppColors.onSurface,
                    secondaryTextColor: AppColors.onSurfaceVariant,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final log = filteredLogs[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 250 + (index * 40)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 15 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: _BrewLogCard(
                        log: log,
                        surfaceColor: AppColors.surfaceContainerLow,
                        surfaceHighColor: AppColors.surfaceContainerHigh,
                        textColor: AppColors.onSurface,
                        secondaryTextColor: AppColors.onSurfaceVariant,
                        ratingColor: AppColors.secondary,
                        tertiaryColor: AppColors.tertiary,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: AppColors.surfaceContainer, width: 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.onSecondary : textColor,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color surfaceColor;
  final Color iconColor;
  final Color textColor;
  final Color secondaryTextColor;

  const _EmptyState({
    required this.surfaceColor,
    required this.iconColor,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_cafe_outlined,
              size: 48,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No brews yet',
            style: GoogleFonts.notoSerif(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your brew history will appear here',
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrewLogCard extends StatelessWidget {
  final BrewLog log;
  final Color surfaceColor;
  final Color surfaceHighColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color ratingColor;
  final Color tertiaryColor;

  const _BrewLogCard({
    required this.log,
    required this.surfaceColor,
    required this.surfaceHighColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.ratingColor,
    required this.tertiaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = log.brewTime.inMinutes;
    final seconds = log.brewTime.inSeconds % 60;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.surfaceContainer,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: surfaceHighColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    log.method.displayName.substring(0, 1),
                    style: GoogleFonts.notoSerif(
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.method.displayName,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$minutes:${seconds.toString().padLeft(2, '0')} • ${log.dose}g / ${log.yield_}g',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (log.rating != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < log.rating! ? Icons.star : Icons.star_border,
                        size: 18,
                        color: ratingColor,
                      ),
                    ),
                  ),
              ],
            ),
            if (log.flavorTags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: log.flavorTags.map<Widget>((tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: tertiaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: tertiaryColor,
                    ),
                  ),
                )).toList(),
              ),
            ],
            if (log.notes != null && log.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                log.notes!,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: secondaryTextColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
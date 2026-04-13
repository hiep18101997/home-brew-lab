import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/beans_provider.dart';
import '../../providers/brew_logs_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beansAsync = ref.watch(beansProvider);
    final brewLogsAsync = ref.watch(brewLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Profile',
          style: GoogleFonts.notoSerif(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // User Card - Glassmorphism avatar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.surfaceContainer,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Glassmorphic avatar
                ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surfaceContainerHighest,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Home Barista',
                        style: GoogleFonts.notoSerif(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Track your coffee journey',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Stats Section
          Text(
            'Your Journey',
            style: GoogleFonts.notoSerif(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Stats grid
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _StatCard(
                  value: brewLogsAsync.when(
                    data: (logs) => '${logs.length}',
                    loading: () => '-',
                    error: (_, __) => '!',
                  ),
                  label: 'Total Brews',
                  icon: Icons.local_cafe_outlined,
                  backgroundColor: AppColors.surfaceContainerLow,
                  iconColor: AppColors.secondary,
                  textColor: AppColors.onSurface,
                  labelColor: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _StatCard(
                  value: beansAsync.when(
                    data: (beans) => '${beans.length}',
                    loading: () => '-',
                    error: (_, __) => '!',
                  ),
                  label: 'Beans',
                  icon: Icons.coffee_outlined,
                  backgroundColor: AppColors.surfaceContainer,
                  iconColor: AppColors.primary,
                  textColor: AppColors.onSurface,
                  labelColor: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _StatCard(
                  value: brewLogsAsync.when(
                    data: (logs) => '${logs.where((l) => l.rating != null && l.rating! >= 4).length}',
                    loading: () => '-',
                    error: (_, __) => '!',
                  ),
                  label: 'Favorites',
                  icon: Icons.favorite_outline,
                  backgroundColor: AppColors.surfaceContainer,
                  iconColor: AppColors.tertiary,
                  textColor: AppColors.onSurface,
                  labelColor: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: _StatCard(
                  value: brewLogsAsync.when(
                    data: (logs) {
                      final total = logs.fold<double>(0, (sum, log) => sum + log.dose);
                      return '${total.toStringAsFixed(0)}g';
                    },
                    loading: () => '-',
                    error: (_, __) => '!',
                  ),
                  label: 'Total Coffee',
                  icon: Icons.scale_outlined,
                  backgroundColor: AppColors.surfaceContainerLow,
                  iconColor: AppColors.primary,
                  textColor: AppColors.onSurface,
                  labelColor: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // About Section
          Text(
            'About',
            style: GoogleFonts.notoSerif(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.surfaceContainer,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _InfoTile(
                  icon: Icons.info_outline,
                  title: 'Coffee Brewing Companion',
                  subtitle: 'Version 1.0.0',
                ),
                Divider(
                  height: 1,
                  color: AppColors.surfaceContainer,
                ),
                _InfoTile(
                  icon: Icons.storage_outlined,
                  title: 'Local Storage',
                  subtitle: 'All data stored on device',
                ),
                Divider(
                  height: 1,
                  color: AppColors.surfaceContainer,
                ),
                _InfoTile(
                  icon: Icons.palette_outlined,
                  title: 'Design',
                  subtitle: 'The Articulated Pour',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color labelColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.surfaceContainer,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.notoSerif(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
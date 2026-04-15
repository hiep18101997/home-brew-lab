import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/bean.dart';

class BeanCard extends StatelessWidget {
  final Bean bean;
  final VoidCallback? onTap;

  const BeanCard({
    super.key,
    required this.bean,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final weightPercent = bean.weightInitial != null && bean.weightInitial! > 0
        ? bean.weightRemaining / bean.weightInitial!
        : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceContainer, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Bean image or placeholder
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.coffee,
                    color: AppColors.secondary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bean.name,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bean.roaster,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Low weight warning
                if (bean.weightRemaining < 50)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Low',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Roast level and process badges
            if (bean.roastLevel != null || bean.process != null)
              Row(
                children: [
                  if (bean.roastLevel != null)
                    _InfoBadge(
                      icon: Icons.local_fire_department,
                      label: bean.roastLevel!,
                      color: _getRoastColor(bean.roastLevel!),
                    ),
                  if (bean.roastLevel != null && bean.process != null)
                    const SizedBox(width: 8),
                  if (bean.process != null)
                    _InfoBadge(
                      icon: Icons.science,
                      label: bean.process!,
                      color: AppColors.primary,
                    ),
                ],
              ),

            if (bean.roastLevel != null || bean.process != null)
              const SizedBox(height: 12),

            // Weight progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${bean.weightRemaining.toStringAsFixed(0)}g',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    if (bean.weightInitial != null)
                      Text(
                        'of ${bean.weightInitial!.toStringAsFixed(0)}g',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: weightPercent.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: weightPercent < 0.2 ? Colors.orange : AppColors.secondary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Origin (if available)
            if (bean.origin != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.place,
                    size: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    bean.origin!,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getRoastColor(String roastLevel) {
    switch (roastLevel.toLowerCase()) {
      case 'light':
        return Colors.amber;
      case 'medium-light':
        return Colors.orange;
      case 'medium':
        return Colors.deepOrange;
      case 'medium-dark':
        return Colors.brown;
      case 'dark':
        return Colors.brown.shade800;
      default:
        return AppColors.secondary;
    }
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

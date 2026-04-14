import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/beans_provider.dart';
import '../../../domain/entities/bean.dart';

class BeanListScreen extends ConsumerWidget {
  const BeanListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beansAsync = ref.watch(beansProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'My Beans',
          style: GoogleFonts.notoSerif(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      floatingActionButton: _GlassFAB(
        onPressed: () => context.push('/beans/add'),
        backgroundColor: AppColors.secondary,
        iconColor: AppColors.onSecondary,
      ),
      body: beansAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: AppColors.secondary),
        ),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
          ),
        ),
        data: (beans) {
          if (beans.isEmpty) {
            return _EmptyBeanState(
              backgroundColor: AppColors.surfaceContainerLow,
              iconColor: AppColors.onSurfaceVariant,
              textColor: AppColors.onSurface,
              secondaryTextColor: AppColors.onSurfaceVariant,
              buttonColor: AppColors.secondary,
              buttonTextColor: AppColors.onSecondary,
              onPressed: () => context.push('/beans/add'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: beans.length,
            itemBuilder: (context, index) {
              final bean = beans[index];
              return _BeanCard(
                bean: bean,
                surfaceColor: AppColors.surfaceContainerLow,
                surfaceHighColor: AppColors.surfaceContainerHigh,
                primaryColor: AppColors.primary,
                secondaryColor: AppColors.secondary,
                onSurfaceColor: AppColors.onSurface,
                onSurfaceVariantColor: AppColors.onSurfaceVariant,
                tertiaryColor: AppColors.tertiary,
                onTap: () => context.push('/beans/${bean.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _GlassFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;

  const _GlassFAB({
    required this.onPressed,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(Icons.add, color: iconColor),
      ),
    );
  }
}

class _EmptyBeanState extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback onPressed;

  const _EmptyBeanState({
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.coffee_outlined,
                size: 48,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No beans yet',
              style: GoogleFonts.notoSerif(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first coffee bean',
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [buttonColor, buttonColor.withOpacity(0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton.icon(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                icon: Icon(Icons.add, color: buttonTextColor),
                label: Text(
                  'Add Bean',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: buttonTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeanCard extends StatelessWidget {
  final Bean bean;
  final Color surfaceColor;
  final Color surfaceHighColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color onSurfaceColor;
  final Color onSurfaceVariantColor;
  final Color tertiaryColor;
  final VoidCallback onTap;

  const _BeanCard({
    required this.bean,
    required this.surfaceColor,
    required this.surfaceHighColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onSurfaceColor,
    required this.onSurfaceVariantColor,
    required this.tertiaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final weightPercent = bean.weightInitial != null && bean.weightInitial! > 0
        ? (bean.weightRemaining / bean.weightInitial!).clamp(0.0, 1.0)
        : 1.0;

    final isLowStock = bean.weightRemaining < 20;
    final isMediumStock = bean.weightRemaining >= 20 && bean.weightRemaining < 50;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLowStock
                ? secondaryColor.withOpacity(0.3)
                : AppColors.surfaceContainer,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Bean image or coffee icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: surfaceHighColor,
                          borderRadius: BorderRadius.circular(12),
                          image: bean.imageUrl != null
                              ? DecorationImage(
                                  image: FileImage(File(bean.imageUrl!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: bean.imageUrl == null
                            ? Icon(
                                Icons.coffee,
                                color: primaryColor,
                                size: 24,
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bean.name,
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: onSurfaceColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              bean.roaster,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: onSurfaceVariantColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stock indicator pill
                      _StockPill(
                        weight: bean.weightRemaining,
                        secondaryColor: secondaryColor,
                        tertiaryColor: tertiaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Weight bar with gradient fill
                  _WeightBar(
                    weightPercent: weightPercent,
                    isLowStock: isLowStock,
                    isMediumStock: isMediumStock,
                    secondaryColor: secondaryColor,
                    tertiaryColor: tertiaryColor,
                    surfaceHighColor: surfaceHighColor,
                    onSurfaceVariantColor: onSurfaceVariantColor,
                    weightRemaining: bean.weightRemaining,
                    weightInitial: bean.weightInitial,
                  ),

                  if (bean.origin != null || bean.roastLevel != null) ...[
                    const SizedBox(height: 12),
                    // Origin and roast level tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if (bean.origin != null)
                          _InfoChip(
                            label: bean.origin!,
                            icon: Icons.place_outlined,
                            surfaceHighColor: surfaceHighColor,
                            onSurfaceVariantColor: onSurfaceVariantColor,
                          ),
                        if (bean.roastLevel != null)
                          _InfoChip(
                            label: bean.roastLevel!,
                            icon: Icons.whatshot_outlined,
                            surfaceHighColor: surfaceHighColor,
                            onSurfaceVariantColor: onSurfaceVariantColor,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockPill extends StatelessWidget {
  final double weight;
  final Color secondaryColor;
  final Color tertiaryColor;

  const _StockPill({
    required this.weight,
    required this.secondaryColor,
    required this.tertiaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isLow = weight < 20;
    final isMedium = weight >= 20 && weight < 50;

    if (weight >= 50) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isLow
            ? AppColors.error.withOpacity(0.15)
            : secondaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLow ? Icons.warning_rounded : Icons.inventory_2_outlined,
            size: 12,
            color: isLow ? AppColors.error : secondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            isLow ? 'Low' : 'Medium',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isLow ? AppColors.error : secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightBar extends StatelessWidget {
  final double weightPercent;
  final bool isLowStock;
  final bool isMediumStock;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color surfaceHighColor;
  final Color onSurfaceVariantColor;
  final double weightRemaining;
  final double? weightInitial;

  const _WeightBar({
    required this.weightPercent,
    required this.isLowStock,
    required this.isMediumStock,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.surfaceHighColor,
    required this.onSurfaceVariantColor,
    required this.weightRemaining,
    this.weightInitial,
  });

  @override
  Widget build(BuildContext context) {
    Color barColor;
    if (isLowStock) {
      barColor = AppColors.error;
    } else if (isMediumStock) {
      barColor = secondaryColor;
    } else {
      barColor = tertiaryColor;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${weightRemaining.toStringAsFixed(0)}g remaining',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: onSurfaceVariantColor,
              ),
            ),
            if (weightInitial != null)
              Text(
                'of ${weightInitial!.toStringAsFixed(0)}g',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: onSurfaceVariantColor.withOpacity(0.6),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: surfaceHighColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: weightPercent,
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: barColor.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color surfaceHighColor;
  final Color onSurfaceVariantColor;

  const _InfoChip({
    required this.label,
    required this.icon,
    required this.surfaceHighColor,
    required this.onSurfaceVariantColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: surfaceHighColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: onSurfaceVariantColor,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: onSurfaceVariantColor,
            ),
          ),
        ],
      ),
    );
  }
}
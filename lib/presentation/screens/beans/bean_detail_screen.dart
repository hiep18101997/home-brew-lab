import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/beans_provider.dart';
import '../../../domain/entities/bean.dart';

class BeanDetailScreen extends ConsumerWidget {
  final String id;

  const BeanDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beansAsync = ref.watch(beansProvider);

    return beansAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.secondary),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Error: $e',
            style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
          ),
        ),
      ),
      data: (beans) {
        final bean = beans.where((b) => b.id == id).firstOrNull;
        if (bean == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
            ),
            body: Center(
              child: Text(
                'Bean not found',
                style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
              ),
            ),
          );
        }
        return _BeanDetailContent(
          bean: bean,
          onDelete: () {
            ref.read(beansProvider.notifier).deleteBean(bean.id);
            context.pop();
          },
          onEdit: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Edit coming soon',
                  style: GoogleFonts.manrope(),
                ),
                backgroundColor: AppColors.surfaceContainerHigh,
              ),
            );
          },
        );
      },
    );
  }
}

class _BeanDetailContent extends StatelessWidget {
  final Bean bean;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _BeanDetailContent({
    required this.bean,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final weightPercent = bean.weightInitial != null && bean.weightInitial! > 0
        ? bean.weightRemaining / bean.weightInitial!
        : 1.0;
    final isLowStock = bean.weightRemaining < 20;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          bean.name,
          style: GoogleFonts.notoSerif(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.onSurfaceVariant),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete, color: AppColors.onSurfaceVariant),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          // Weight Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.coffee,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${bean.weightRemaining.toStringAsFixed(0)}g',
                            style: GoogleFonts.notoSerif(
                              fontSize: 40,
                              fontWeight: FontWeight.w400,
                              color: AppColors.onSurface,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'remaining',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLowStock)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning, color: AppColors.secondary, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Low',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                // Progress bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: weightPercent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isLowStock ? AppColors.secondary : AppColors.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (bean.weightInitial != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'of ${bean.weightInitial!.toStringAsFixed(0)}g initial',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Details Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Details',
                  style: GoogleFonts.notoSerif(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _DetailRow(
                  label: 'Roaster',
                  value: bean.roaster,
                  textColor: AppColors.onSurface,
                  labelColor: AppColors.onSurfaceVariant,
                ),
                if (bean.origin != null)
                  _DetailRow(
                    label: 'Origin',
                    value: bean.origin!,
                    textColor: AppColors.onSurface,
                    labelColor: AppColors.onSurfaceVariant,
                  ),
                if (bean.variety != null)
                  _DetailRow(
                    label: 'Variety',
                    value: bean.variety!,
                    textColor: AppColors.onSurface,
                    labelColor: AppColors.onSurfaceVariant,
                  ),
                if (bean.process != null)
                  _DetailRow(
                    label: 'Process',
                    value: bean.process!,
                    textColor: AppColors.onSurface,
                    labelColor: AppColors.onSurfaceVariant,
                  ),
                if (bean.roastLevel != null)
                  _DetailRow(
                    label: 'Roast Level',
                    value: bean.roastLevel!,
                    textColor: AppColors.onSurface,
                    labelColor: AppColors.onSurfaceVariant,
                  ),
                if (bean.roastDate != null)
                  _DetailRow(
                    label: 'Roast Date',
                    value: '${bean.roastDate!.day}/${bean.roastDate!.month}/${bean.roastDate!.year}',
                    textColor: AppColors.onSurface,
                    labelColor: AppColors.onSurfaceVariant,
                  ),
              ],
            ),
          ),

          if (bean.notes != null && bean.notes!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: GoogleFonts.notoSerif(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bean.notes!,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delete Bean?',
                style: GoogleFonts.notoSerif(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete "${bean.name}"? This action cannot be undone.',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                      child: Text(
                        'Delete',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onError,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textColor;
  final Color labelColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.textColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: labelColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../domain/entities/brew_guide.dart';
import '../../domain/constants/brew_methods.dart';

class BrewGuideCard extends StatelessWidget {
  final BrewGuide guide;
  final VoidCallback? onTap;
  final bool isSelected;

  const BrewGuideCard({
    super.key,
    required this.guide,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      _getMethodIcon(guide.method),
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guide.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${guide.steps.length} steps • ${_formatDuration(guide.totalTime)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: guide.steps.map((step) {
                  return Chip(
                    label: Text(
                      step.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Text(
                '${guide.defaultDose.toStringAsFixed(0)}g coffee • ${guide.defaultYield.toStringAsFixed(0)}g water',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMethodIcon(BrewMethod method) {
    switch (method) {
      case BrewMethod.v60:
        return Icons.coffee;
      case BrewMethod.chemex:
        return Icons.science;
      case BrewMethod.espresso:
        return Icons.local_cafe;
      case BrewMethod.aeropress:
        return Icons.compress;
      case BrewMethod.frenchPress:
        return Icons.coffee_maker;
      case BrewMethod.phin:
        return Icons.filter_alt;
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
    return '${seconds}s';
  }
}
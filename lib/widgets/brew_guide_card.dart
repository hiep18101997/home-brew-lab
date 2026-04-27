import 'package:flutter/material.dart';
import '../../core/constants/brew_methods.dart';

class BrewGuideCard extends StatelessWidget {
  final BrewMethod method;
  final VoidCallback? onTap;
  final bool isSelected;

  const BrewGuideCard({
    super.key,
    required this.method,
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
                      _getMethodIcon(method),
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
                          method.displayName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          method.category,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
}
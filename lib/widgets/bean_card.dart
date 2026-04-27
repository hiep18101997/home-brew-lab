import 'package:flutter/material.dart';
import '../../../features/beans/domain/entities/bean.dart';

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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.coffee,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bean.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          bean.roaster,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (bean.weightRemaining < 20)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Low',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${bean.weightRemaining.toStringAsFixed(0)}g',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (bean.weightInitial != null)
                              Text(
                                'of ${bean.weightInitial!.toStringAsFixed(0)}g',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: weightPercent,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (bean.origin != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Origin: ${bean.origin}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
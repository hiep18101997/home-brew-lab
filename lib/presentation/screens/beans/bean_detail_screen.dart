import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/beans_provider.dart';
import '../../../domain/entities/bean.dart';

class BeanDetailScreen extends ConsumerWidget {
  final String id;

  const BeanDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beansAsync = ref.watch(beansProvider);

    return beansAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (beans) {
        final bean = beans.where((b) => b.id == id).firstOrNull;
        if (bean == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Bean not found')),
          );
        }
        return _BeanDetailContent(bean: bean);
      },
    );
  }
}

class _BeanDetailContent extends ConsumerWidget {
  final Bean bean;

  const _BeanDetailContent({required this.bean});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightPercent = bean.weightInitial != null && bean.weightInitial! > 0
        ? bean.weightRemaining / bean.weightInitial!
        : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(bean.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit functionality - deferred to future iteration
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Weight card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.coffee,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${bean.weightRemaining.toStringAsFixed(0)}g',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'remaining',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: weightPercent,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  if (bean.weightInitial != null)
                    Text(
                      'of ${bean.weightInitial!.toStringAsFixed(0)}g initial',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (bean.weightRemaining < 20) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Low stock warning',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Details card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(label: 'Roaster', value: bean.roaster),
                  if (bean.origin != null) _DetailRow(label: 'Origin', value: bean.origin!),
                  if (bean.variety != null) _DetailRow(label: 'Variety', value: bean.variety!),
                  if (bean.process != null) _DetailRow(label: 'Process', value: bean.process!),
                  if (bean.roastLevel != null) _DetailRow(label: 'Roast Level', value: bean.roastLevel!),
                  if (bean.roastDate != null)
                    _DetailRow(
                      label: 'Roast Date',
                      value: '${bean.roastDate!.day}/${bean.roastDate!.month}/${bean.roastDate!.year}',
                    ),
                ],
              ),
            ),
          ),

          if (bean.notes != null && bean.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(bean.notes!),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bean?'),
        content: Text('Are you sure you want to delete "${bean.name}"?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(beansProvider.notifier).deleteBean(bean.id);
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

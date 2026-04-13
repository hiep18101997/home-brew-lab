import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/beans_provider.dart';
import '../../../providers/brew_logs_provider.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beansAsync = ref.watch(beansProvider);
    final brewLogsAsync = ref.watch(brewLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Companion'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting
          Text(
            'Welcome back!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Ready for your next brew?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),

          // Quick stats
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Beans',
                  value: beansAsync.when(
                    data: (beans) => '${beans.length}',
                    loading: () => '-',
                    error: (_, __) => '!',
                  ),
                  icon: Icons.coffee,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Brews',
                  value: brewLogsAsync.when(
                    data: (logs) => '${logs.length}',
                    loading: () => '-',
                    error: (_, __) => '!',
                  ),
                  icon: Icons.local_cafe,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent brews
          Text(
            'Recent Brews',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          brewLogsAsync.when(
            data: (logs) {
              if (logs.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_cafe_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No brews yet',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => context.push('/brew'),
                          icon: const Icon(Icons.add),
                          label: const Text('Start your first brew'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: logs.take(3).map((log) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(log.method.displayName.substring(0, 1)),
                    ),
                    title: Text(log.method.displayName),
                    subtitle: Text('${log.dose}g / ${log.yield_}g'),
                    trailing: log.rating != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < log.rating! ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                          )
                        : null,
                  ),
                )).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

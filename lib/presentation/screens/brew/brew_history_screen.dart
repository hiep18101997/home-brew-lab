import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/brew_logs_provider.dart';
import '../../../core/constants/brew_methods.dart';

class BrewHistoryScreen extends ConsumerWidget {
  const BrewHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brewLogsAsync = ref.watch(brewLogsProvider);
    final filter = ref.watch(brewLogsFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brew History'),
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: filter == null,
                  onSelected: (_) {
                    ref.read(brewLogsFilterProvider.notifier).state = null;
                  },
                ),
                const SizedBox(width: 8),
                ...BrewMethod.values.map((method) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(method.displayName),
                    selected: filter == method,
                    onSelected: (_) {
                      ref.read(brewLogsFilterProvider.notifier).state = method;
                    },
                  ),
                )),
              ],
            ),
          ),

          // Brew logs list
          Expanded(
            child: brewLogsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (logs) {
                // Apply filter
                final filteredLogs = filter != null
                    ? logs.where((l) => l.method == filter).toList()
                    : logs;

                if (filteredLogs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_cafe_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No brews yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your brew history will appear here',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final log = filteredLogs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(log.method.displayName.substring(0, 1)),
                        ),
                        title: Text(log.method.displayName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${log.dose}g / ${log.yield_}g'),
                            Text(
                              '${log.brewTime.inMinutes}:${(log.brewTime.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
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
                        isThreeLine: true,
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
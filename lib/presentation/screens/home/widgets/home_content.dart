import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/beans/presentation/bloc/beans_bloc.dart';
import '../../../../features/beans/presentation/bloc/beans_event.dart';
import '../../../../features/beans/presentation/bloc/beans_state.dart';
import '../../../../features/brew/presentation/bloc/brew_bloc.dart';
import '../../../../features/brew/presentation/bloc/brew_event.dart';
import '../../../../features/brew/presentation/bloc/brew_state.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Companion'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome back!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Ready for your next brew?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Beans',
                  value: BlocBuilder<BeansBloc, BeansState>(
                    builder: (context, state) {
                      if (state is BeansSuccess) {
                        return Text('${state.beans.length}');
                      }
                      return const Text('-');
                    },
                  ),
                  icon: Icons.coffee,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Brews',
                  value: BlocBuilder<BrewBloc, BrewState>(
                    builder: (context, state) {
                      if (state is BrewSuccess) {
                        return Text('${state.logs.length}');
                      }
                      return const Text('-');
                    },
                  ),
                  icon: Icons.local_cafe,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Brews',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          BlocBuilder<BrewBloc, BrewState>(
            builder: (context, state) {
              if (state is BrewLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is BrewSuccess) {
                if (state.logs.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_cafe_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
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
                  children: state.logs.take(3).map((log) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(log.method.displayName.substring(0, 1)),
                      ),
                      title: Text(log.method.displayName),
                      subtitle: Text('${log.dose.toStringAsFixed(0)}g / ${log.yield_.toStringAsFixed(0)}g'),
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
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final Widget value;
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
            DefaultTextStyle(
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              child: value,
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
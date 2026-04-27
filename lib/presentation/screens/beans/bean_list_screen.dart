import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/beans/presentation/bloc/beans_bloc.dart';
import '../../../features/beans/presentation/bloc/beans_state.dart';
import '../../widgets/bean_card.dart';

class BeanListScreen extends StatelessWidget {
  const BeanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Beans')),
      body: BlocConsumer<BeansBloc, BeansState>(
        listener: (context, state) {
          if (state is BeansError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is BeansLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BeansSuccess) {
            if (state.beans.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.coffee_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No beans yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first coffee bean',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context.push('/beans/add'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Bean'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.beans.length,
              itemBuilder: (context, index) {
                final bean = state.beans[index];
                return BeanCard(
                  bean: bean,
                  onTap: () => context.push('/beans/${bean.id}'),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/beans/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/brew/presentation/bloc/brew_bloc.dart';
import '../../../features/brew/presentation/bloc/brew_state.dart';

class BrewHistoryScreen extends StatelessWidget {
  const BrewHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Brew History')),
      body: BlocConsumer<BrewBloc, BrewState>(
        listener: (context, state) {
          if (state is BrewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is BrewLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BrewSuccess) {
            if (state.logs.isEmpty) {
              return const Center(child: Text('No brews logged yet'));
            }
            return ListView.builder(
              itemCount: state.logs.length,
              itemBuilder: (context, index) {
                final log = state.logs[index];
                return ListTile(
                  title: Text('${log.method.name} - ${log.dose}g'),
                  subtitle: Text(log.createdAt.toString()),
                  onTap: () => context.push('/brew/${log.id}'),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
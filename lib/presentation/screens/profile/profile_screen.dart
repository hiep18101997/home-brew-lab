import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Anonymous user card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Anonymous User',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to sync your data',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      // TODO: Show login options
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coming in Phase 2')),
                      );
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Sign In'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // App info
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Coffee Brewing Companion'),
                  subtitle: const Text('Version 1.0.0'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.storage_outlined),
                  title: const Text('Local Storage'),
                  subtitle: const Text('All data stored on device'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

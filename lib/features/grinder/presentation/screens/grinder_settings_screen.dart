import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/grinder_profile.dart';
import '../bloc/bloc.dart';

class GrinderSettingsScreen extends StatelessWidget {
  const GrinderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grinder Settings')),
      body: BlocConsumer<GrinderBloc, GrinderState>(
        listener: (context, state) {
          if (state is GrinderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is GrinderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GrinderBrandsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Brand',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildBrandSelector(context, state),
                  if (state.selectedBrand != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Select Model',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildModelSelector(context, state),
                  ],
                  if (state.selectedProfile != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Select Brew Method',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildBrewMethodSelector(context, state),
                  ],
                  if (state.currentSettings != null) ...[
                    const SizedBox(height: 24),
                    _buildSettingsCard(context, state.currentSettings!),
                  ],
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBrandSelector(BuildContext context, GrinderBrandsLoaded state) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: state.brands.map((brand) {
        final isSelected = state.selectedBrand == brand;
        return ChoiceChip(
          label: Text(brand.displayName),
          selected: isSelected,
          onSelected: (_) {
            context.read<GrinderBloc>().add(GrinderBrandSelected(brand));
          },
        );
      }).toList(),
    );
  }

  Widget _buildModelSelector(BuildContext context, GrinderBrandsLoaded state) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: state.grindersForBrand.map((profile) {
        final isSelected = state.selectedProfile?.model == profile.model;
        return ChoiceChip(
          label: Text(profile.model),
          selected: isSelected,
          onSelected: (_) {
            context.read<GrinderBloc>().add(GrinderModelSelected(profile));
          },
        );
      }).toList(),
    );
  }

  Widget _buildBrewMethodSelector(
      BuildContext context, GrinderBrandsLoaded state) {
    final methods = state.selectedProfile?.settings.keys.toList() ?? [];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: methods.map((method) {
        final isSelected = state.selectedBrewMethod == method;
        return ChoiceChip(
          label: Text(_formatBrewMethod(method)),
          selected: isSelected,
          onSelected: (_) {
            context
                .read<GrinderBloc>()
                .add(GrinderBrewMethodSelected(method));
          },
        );
      }).toList(),
    );
  }

  Widget _buildSettingsCard(BuildContext context, GrinderSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended Settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildSettingRow(context, 'Grind Size', settings.grindSize),
            _buildSettingRow(context, 'Dose', '${settings.dose}g'),
            _buildSettingRow(context, 'Yield', '${settings.yield_.toInt()}g'),
            _buildSettingRow(context, 'Brew Time', settings.brewTime),
            if (settings.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 4),
              Text(settings.notes),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  String _formatBrewMethod(String method) {
    return method
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
        )
        .trim()
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}

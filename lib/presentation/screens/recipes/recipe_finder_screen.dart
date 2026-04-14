import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/brew_methods.dart';
import '../../../domain/entities/grinder_profile.dart';
import '../../../data/grinder_settings_repository.dart';
import '../../providers/grinder_settings_provider.dart';

class RecipeFinderScreen extends ConsumerWidget {
  const RecipeFinderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(grinderSettingsProvider);
    final notifier = ref.read(grinderSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Recipe Finder',
          style: GoogleFonts.notoSerif(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Brew Method Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: BrewMethod.values.map((method) {
                  final isSelected = state.selectedMethod == method;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _MethodChip(
                      label: method.displayName,
                      isSelected: isSelected,
                      onTap: () => notifier.selectMethod(method),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Grinder Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _DropdownCard(
                    label: 'Brand',
                    value: state.selectedBrand?.displayName,
                    items: GrinderBrand.values.map((b) => b.displayName).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      final brand = GrinderBrand.values.firstWhere((b) => b.displayName == value);
                      notifier.selectBrand(brand);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DropdownCard(
                    label: 'Model',
                    value: state.selectedModel,
                    items: state.selectedBrand != null
                        ? notifier.getModelsForBrand(state.selectedBrand!).map((p) => p.model).toList()
                        : [],
                    onChanged: (value) {
                            if (value == null || state.selectedBrand == null) return;
                            notifier.selectModel(value);
                          },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recipe Cards
          Expanded(
            child: _buildRecipeList(state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList(GrinderSettingsState state, GrinderSettingsNotifier notifier) {
    if (state.selectedBrand == null || state.selectedModel == null) {
      return _EmptyState(
        icon: Icons.tune,
        title: 'Select your grinder',
        subtitle: 'Choose brand and model to see recommended recipes',
      );
    }

    final profiles = GrinderSettingsRepository.getByBrand(state.selectedBrand!);
    final profile = profiles.where((p) => p.model == state.selectedModel).firstOrNull;

    if (profile == null) {
      return _EmptyState(
        icon: Icons.search_off,
        title: 'No data for this selection',
        subtitle: 'Try a different grinder model',
      );
    }

    final settings = profile.settings[state.selectedMethod];
    if (settings == null) {
      return _EmptyState(
        icon: Icons.coffee_outlined,
        title: 'No recipe for ${state.selectedMethod.displayName}',
        subtitle: 'This grinder does not have settings for this method yet',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RecipeCard(
            profile: profile,
            method: state.selectedMethod,
            settings: settings,
          ),
        ],
      ),
    );
  }
}

class _MethodChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.surfaceContainer,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.onSecondary : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

class _DropdownCard extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownCard({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: AppColors.surfaceContainerLow,
            hint: Text(
              'Select',
              style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
            ),
            items: items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: GoogleFonts.manrope(fontSize: 14)),
            )).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final GrinderProfile profile;
  final BrewMethod method;
  final GrinderSettings settings;

  const _RecipeCard({
    required this.profile,
    required this.method,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.coffee, color: AppColors.secondary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName,
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _CountryBadge(country: profile.country),
                        const SizedBox(width: 8),
                        Text(
                          method.displayName,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.surfaceContainer, height: 1),
          const SizedBox(height: 20),

          // Grind Size - Highlight
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.tune, color: AppColors.secondary, size: 24),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grind Size',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      settings.grindSize,
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Recipe Details
          Row(
            children: [
              Expanded(
                child: _RecipeDetail(
                  icon: Icons.scale,
                  label: 'Dose',
                  value: '${settings.dose.toStringAsFixed(0)}g',
                ),
              ),
              Expanded(
                child: _RecipeDetail(
                  icon: Icons.water_drop,
                  label: 'Yield',
                  value: '${settings.yield_.toStringAsFixed(0)}ml',
                ),
              ),
              Expanded(
                child: _RecipeDetail(
                  icon: Icons.timer,
                  label: 'Time',
                  value: settings.brewTime,
                ),
              ),
            ],
          ),

          if (settings.notes.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.onSurfaceVariant, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      settings.notes,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CountryBadge extends StatelessWidget {
  final String country;
  const _CountryBadge({required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        country,
        style: GoogleFonts.manrope(
          fontSize: 10,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _RecipeDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RecipeDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.notoSerif(
                fontSize: 20,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

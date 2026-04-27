import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../domain/usecases/get_recipes.dart';
import '../../domain/usecases/get_recipe_by_id.dart';
import '../../domain/usecases/create_recipe.dart';
import '../bloc/recipe_bloc.dart';
import '../bloc/recipe_event.dart';
import '../bloc/recipe_state.dart';

class RecipeFinderScreen extends StatelessWidget {
  const RecipeFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecipeBloc(
        getRecipes: GetRecipes(GetIt.instance<RecipeRepository>()),
        getRecipeById: GetRecipeById(GetIt.instance<RecipeRepository>()),
        createRecipe: CreateRecipe(GetIt.instance<RecipeRepository>()),
        repository: GetIt.instance<RecipeRepository>(),
      )..add(RecipesRequested()),
      child: const RecipeFinderView(),
    );
  }
}

class RecipeFinderView extends StatefulWidget {
  const RecipeFinderView({super.key});

  @override
  State<RecipeFinderView> createState() => _RecipeFinderViewState();
}

class _RecipeFinderViewState extends State<RecipeFinderView> {
  int? _selectedGrindSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Finder'),
      ),
      body: Column(
        children: [
          _buildGrindSizeSelector(context),
          Expanded(
            child: BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is RecipeError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }
                if (state is RecipesSuccess) {
                  final recipes = _selectedGrindSize != null
                      ? state.recipes
                          .where((r) => r.grindSize == _selectedGrindSize)
                          .toList()
                      : state.recipes;
                  return _buildRecipeList(context, recipes);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrindSizeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Grind Size',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildGrindSizeChip(context, null, 'All'),
                ...List.generate(10, (index) {
                  return _buildGrindSizeChip(
                    context,
                    index + 1,
                    '${index + 1}',
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrindSizeChip(
    BuildContext context,
    int? grindSize,
    String label,
  ) {
    final isSelected = _selectedGrindSize == grindSize;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedGrindSize = selected ? grindSize : null;
          });
        },
      ),
    );
  }

  Widget _buildRecipeList(BuildContext context, List<Recipe> recipes) {
    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.coffee_maker_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No recipes found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different grind size filter',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withValues(alpha:0.7),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _RecipeCard(
          recipe: recipe,
          onTap: () => _showRecipeDetails(context, recipe),
        );
      },
    );
  }

  void _showRecipeDetails(BuildContext context, Recipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _RecipeDetailsSheet(recipe: recipe),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      recipe.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      recipe.method.displayName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(
                    context,
                    Icons.grass,
                    'Grind ${recipe.grindSize}',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    context,
                    Icons.thermostat,
                    '${recipe.waterTemperature}C',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    context,
                    Icons.timer,
                    _formatDuration(recipe.brewTime),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${recipe.dose}g : ${recipe.yield_}g',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (recipe.flavorTags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: recipe.flavorTags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryContainer
                            .withValues(alpha:0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.7),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}

class _RecipeDetailsSheet extends StatelessWidget {
  final Recipe recipe;

  const _RecipeDetailsSheet({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                recipe.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  recipe.method.displayName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailSection(
                context,
                'Brew Parameters',
                [
                  _buildDetailRow(context, 'Dose', '${recipe.dose}g'),
                  _buildDetailRow(context, 'Yield', '${recipe.yield_}g'),
                  _buildDetailRow(
                      context, 'Ratio', '${(recipe.yield_ / recipe.dose).toStringAsFixed(1)}:1'),
                  _buildDetailRow(context, 'Grind Size', '${recipe.grindSize}'),
                  _buildDetailRow(
                      context, 'Water Temp', '${recipe.waterTemperature}C'),
                  _buildDetailRow(
                      context, 'Brew Time', _formatDuration(recipe.brewTime)),
                ],
              ),
              if (recipe.flavorTags.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildDetailSection(
                  context,
                  'Flavor Notes',
                  [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recipe.flavorTags.map((tag) {
                        return Chip(label: Text(tag));
                      }).toList(),
                    ),
                  ],
                ),
              ],
              if (recipe.notes != null && recipe.notes!.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildDetailSection(
                  context,
                  'Notes',
                  [
                    Text(recipe.notes!),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha:0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}

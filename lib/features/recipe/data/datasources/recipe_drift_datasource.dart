import '../models/recipe_dto.dart';
import '../../../../database.dart';

class RecipeDriftDataSource {
  final AppDatabase _db;

  RecipeDriftDataSource(this._db);

  Future<List<RecipeDto>> getAllRecipes() async {
    final rows = await _db.select(_db.recipesTable).get();
    return rows.map((row) => RecipeDto.fromDrift(row)).toList();
  }

  Future<RecipeDto?> getRecipeById(int id) async {
    final row = await (_db.select(_db.recipesTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? RecipeDto.fromDrift(row) : null;
  }

  Future<RecipeDto> insertRecipe(RecipesTableCompanion recipe) async {
    final id = await _db.into(_db.recipesTable).insert(recipe);
    final result = await getRecipeById(id);
    if (result == null) {
      throw Exception('Failed to insert recipe');
    }
    return result;
  }

  Future<void> updateRecipe(RecipesTableCompanion recipe) async {
    await (_db.update(_db.recipesTable)..where((t) => t.id.equals(recipe.id.value)))
        .write(recipe);
  }

  Future<void> deleteRecipe(int id) async {
    await (_db.delete(_db.recipesTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<RecipeDto>> getRecipesByGrindSize(int grindSize) async {
    final rows = await (_db.select(_db.recipesTable)
          ..where((t) => t.grindSize.equals(grindSize)))
        .get();
    return rows.map((row) => RecipeDto.fromDrift(row)).toList();
  }
}

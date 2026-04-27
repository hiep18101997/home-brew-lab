import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_drift_datasource.dart';
import '../models/recipe_dto.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeDriftDataSource _dataSource;

  RecipeRepositoryImpl(this._dataSource);

  @override
  Future<List<Recipe>> getAllRecipes() async {
    final dtos = await _dataSource.getAllRecipes();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Recipe?> getRecipeById(String id) async {
    final dto = await _dataSource.getRecipeById(int.parse(id));
    return dto?.toEntity();
  }

  @override
  Future<Recipe> createRecipe(Recipe recipe) async {
    final companion = RecipeDto.fromEntity(recipe);
    final inserted = await _dataSource.insertRecipe(companion);
    return inserted.toEntity();
  }

  @override
  Future<Recipe> updateRecipe(Recipe recipe) async {
    final companion = RecipeDto.fromEntity(recipe);
    await _dataSource.updateRecipe(companion);
    return recipe;
  }

  @override
  Future<void> deleteRecipe(String id) async {
    await _dataSource.deleteRecipe(int.parse(id));
  }

  @override
  Future<List<Recipe>> getRecipesByGrindSize(int grindSize) async {
    final dtos = await _dataSource.getRecipesByGrindSize(grindSize);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}

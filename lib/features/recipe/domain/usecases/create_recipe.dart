import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

class CreateRecipe {
  final RecipeRepository repository;

  CreateRecipe(this.repository);

  Future<Recipe> call(Recipe recipe) async {
    return await repository.createRecipe(recipe);
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_recipes.dart';
import '../../domain/usecases/get_recipe_by_id.dart';
import '../../domain/usecases/create_recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetRecipes getRecipes;
  final GetRecipeById getRecipeById;
  final CreateRecipe createRecipe;
  final RecipeRepository repository;

  RecipeBloc({
    required this.getRecipes,
    required this.getRecipeById,
    required this.createRecipe,
    required this.repository,
  }) : super(RecipeInitial()) {
    on<RecipesRequested>(_onRecipesRequested);
    on<RecipeByIdRequested>(_onRecipeByIdRequested);
    on<RecipeCreated>(_onRecipeCreated);
    on<RecipeUpdated>(_onRecipeUpdated);
    on<RecipeDeleted>(_onRecipeDeleted);
    on<RecipesByGrindSizeRequested>(_onRecipesByGrindSizeRequested);
  }

  Future<void> _onRecipesRequested(
    RecipesRequested event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipes = await getRecipes();
      emit(RecipesSuccess(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> _onRecipeByIdRequested(
    RecipeByIdRequested event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipe = await getRecipeById(event.id);
      if (recipe != null) {
        emit(RecipeSuccess(recipe));
      } else {
        emit(const RecipeError('Recipe not found'));
      }
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> _onRecipeCreated(
    RecipeCreated event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      await createRecipe(event.recipe);
      final recipes = await getRecipes();
      emit(RecipesSuccess(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> _onRecipeUpdated(
    RecipeUpdated event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      await repository.updateRecipe(event.recipe);
      final recipes = await getRecipes();
      emit(RecipesSuccess(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> _onRecipeDeleted(
    RecipeDeleted event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      await repository.deleteRecipe(event.id);
      final recipes = await getRecipes();
      emit(RecipesSuccess(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }

  Future<void> _onRecipesByGrindSizeRequested(
    RecipesByGrindSizeRequested event,
    Emitter<RecipeState> emit,
  ) async {
    emit(RecipeLoading());
    try {
      final recipes = await repository.getRecipesByGrindSize(event.grindSize);
      emit(RecipesSuccess(recipes));
    } catch (e) {
      emit(RecipeError(e.toString()));
    }
  }
}

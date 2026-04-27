import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipesSuccess extends RecipeState {
  final List<Recipe> recipes;
  const RecipesSuccess(this.recipes);

  @override
  List<Object?> get props => [recipes];
}

class RecipeSuccess extends RecipeState {
  final Recipe recipe;
  const RecipeSuccess(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class RecipeError extends RecipeState {
  final String message;
  const RecipeError(this.message);

  @override
  List<Object?> get props => [message];
}

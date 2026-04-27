import 'package:equatable/equatable.dart';
import '../../domain/entities/recipe.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class RecipesRequested extends RecipeEvent {}

class RecipeByIdRequested extends RecipeEvent {
  final String id;
  const RecipeByIdRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class RecipeCreated extends RecipeEvent {
  final Recipe recipe;
  const RecipeCreated(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class RecipeUpdated extends RecipeEvent {
  final Recipe recipe;
  const RecipeUpdated(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

class RecipeDeleted extends RecipeEvent {
  final String id;
  const RecipeDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class RecipesByGrindSizeRequested extends RecipeEvent {
  final int grindSize;
  const RecipesByGrindSizeRequested(this.grindSize);

  @override
  List<Object?> get props => [grindSize];
}

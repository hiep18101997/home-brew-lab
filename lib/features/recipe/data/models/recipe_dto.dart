import 'package:drift/drift.dart';
import '../../domain/entities/recipe.dart';
import '../../../../core/constants/brew_methods.dart';
import '../../../../database.dart';

class RecipeDto {
  final int id;
  final String name;
  final String? beanId;
  final String method;
  final double dose;
  final double yield_;
  final int grindSize;
  final int waterTemperature;
  final int brewTimeSeconds;
  final int? rating;
  final String? flavorTags;
  final String? notes;
  final DateTime createdAt;

  RecipeDto({
    required this.id,
    required this.name,
    this.beanId,
    required this.method,
    required this.dose,
    required this.yield_,
    required this.grindSize,
    required this.waterTemperature,
    required this.brewTimeSeconds,
    this.rating,
    this.flavorTags,
    this.notes,
    required this.createdAt,
  });

  factory RecipeDto.fromDrift(RecipesTableData row) {
    return RecipeDto(
      id: row.id,
      name: row.name,
      beanId: row.beanId,
      method: row.method,
      dose: row.dose,
      yield_: row.yieldColumn,
      grindSize: row.grindSize,
      waterTemperature: row.waterTemperature,
      brewTimeSeconds: row.brewTimeSeconds,
      rating: row.rating,
      flavorTags: row.flavorTags,
      notes: row.notes,
      createdAt: row.createdAt,
    );
  }

  Recipe toEntity() {
    return Recipe(
      id: id.toString(),
      name: name,
      beanId: beanId,
      method: _parseBrewMethod(method),
      dose: dose,
      yield_: yield_,
      grindSize: grindSize,
      waterTemperature: waterTemperature,
      brewTime: Duration(seconds: brewTimeSeconds),
      rating: rating,
      flavorTags: flavorTags != null && flavorTags!.isNotEmpty
          ? flavorTags!.split(',')
          : [],
      notes: notes,
      createdAt: createdAt,
    );
  }

  static BrewMethod _parseBrewMethod(String method) {
    return BrewMethod.values.firstWhere(
      (e) => e.name == method,
      orElse: () => BrewMethod.v60,
    );
  }

  static RecipesTableCompanion fromEntity(Recipe entity) {
    final flavorTagsString =
        entity.flavorTags.isNotEmpty ? entity.flavorTags.join(',') : null;

    return RecipesTableCompanion.insert(
      name: entity.name,
      beanId: Value(entity.beanId),
      method: entity.method.name,
      dose: entity.dose,
      yieldColumn: entity.yield_,
      grindSize: entity.grindSize,
      waterTemperature: entity.waterTemperature,
      brewTimeSeconds: entity.brewTime.inSeconds,
      rating: Value(entity.rating),
      flavorTags: Value(flavorTagsString),
      notes: Value(entity.notes),
      createdAt: entity.createdAt,
    );
  }
}

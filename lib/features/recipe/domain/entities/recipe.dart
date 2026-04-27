import 'package:equatable/equatable.dart';
import '../../../../core/constants/brew_methods.dart';

class Recipe extends Equatable {
  final String id;
  final String name;
  final String? beanId;
  final BrewMethod method;
  final double dose;
  final double yield_;
  final int grindSize;
  final int waterTemperature;
  final Duration brewTime;
  final int? rating;
  final List<String> flavorTags;
  final String? notes;
  final DateTime createdAt;

  const Recipe({
    required this.id,
    required this.name,
    this.beanId,
    required this.method,
    required this.dose,
    required this.yield_,
    required this.grindSize,
    required this.waterTemperature,
    required this.brewTime,
    this.rating,
    this.flavorTags = const [],
    this.notes,
    required this.createdAt,
  });

  Recipe copyWith({
    String? id,
    String? name,
    String? beanId,
    BrewMethod? method,
    double? dose,
    double? yield_,
    int? grindSize,
    int? waterTemperature,
    Duration? brewTime,
    int? rating,
    List<String>? flavorTags,
    String? notes,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      beanId: beanId ?? this.beanId,
      method: method ?? this.method,
      dose: dose ?? this.dose,
      yield_: yield_ ?? this.yield_,
      grindSize: grindSize ?? this.grindSize,
      waterTemperature: waterTemperature ?? this.waterTemperature,
      brewTime: brewTime ?? this.brewTime,
      rating: rating ?? this.rating,
      flavorTags: flavorTags ?? this.flavorTags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        beanId,
        method,
        dose,
        yield_,
        grindSize,
        waterTemperature,
        brewTime,
        rating,
        flavorTags,
        notes,
        createdAt,
      ];
}

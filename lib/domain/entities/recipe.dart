import 'package:uuid/uuid.dart';
import '../../core/constants/brew_methods.dart';

class Recipe {
  final String id;
  final String? authorId;
  final String name;
  final BrewMethod method;
  final double dose;
  final double yield_;
  final int grindSize;
  final int waterTemperature;
  final Duration brewTime;
  final List<String> flavorTags;
  final String? description;
  final int likes;
  final bool isPublic;
  final DateTime createdAt;

  const Recipe({
    required this.id,
    this.authorId,
    required this.name,
    required this.method,
    required this.dose,
    required this.yield_,
    required this.grindSize,
    required this.waterTemperature,
    required this.brewTime,
    this.flavorTags = const [],
    this.description,
    this.likes = 0,
    this.isPublic = false,
    required this.createdAt,
  });

  factory Recipe.create({
    String? authorId,
    required String name,
    required BrewMethod method,
    required double dose,
    required double yield_,
    required int grindSize,
    required int waterTemperature,
    required Duration brewTime,
    List<String> flavorTags = const [],
    String? description,
    bool isPublic = false,
  }) {
    return Recipe(
      id: const Uuid().v4(),
      authorId: authorId,
      name: name,
      method: method,
      dose: dose,
      yield_: yield_,
      grindSize: grindSize,
      waterTemperature: waterTemperature,
      brewTime: brewTime,
      flavorTags: flavorTags,
      description: description,
      likes: 0,
      isPublic: isPublic,
      createdAt: DateTime.now(),
    );
  }

  Recipe copyWith({
    String? id,
    String? authorId,
    String? name,
    BrewMethod? method,
    double? dose,
    double? yield_,
    int? grindSize,
    int? waterTemperature,
    Duration? brewTime,
    List<String>? flavorTags,
    String? description,
    int? likes,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      name: name ?? this.name,
      method: method ?? this.method,
      dose: dose ?? this.dose,
      yield_: yield_ ?? this.yield_,
      grindSize: grindSize ?? this.grindSize,
      waterTemperature: waterTemperature ?? this.waterTemperature,
      brewTime: brewTime ?? this.brewTime,
      flavorTags: flavorTags ?? this.flavorTags,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
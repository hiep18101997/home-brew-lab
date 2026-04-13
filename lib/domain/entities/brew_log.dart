import 'package:uuid/uuid.dart';
import '../../core/constants/brew_methods.dart';

class BrewLog {
  final String id;
  final String? beanId;
  final BrewMethod method;
  final double dose; // grams
  final double yield_; // grams
  final int grindSize; // 1-10
  final int waterTemperature; // celsius
  final Duration brewTime;
  final int? rating; // 1-5 stars
  final List<String> flavorTags;
  final String? notes;
  final double? tds;
  final double? extractionYield;
  final DateTime createdAt;

  const BrewLog({
    required this.id,
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
    this.tds,
    this.extractionYield,
    required this.createdAt,
  });

  factory BrewLog.create({
    String? beanId,
    required BrewMethod method,
    required double dose,
    required double yield_,
    required int grindSize,
    required int waterTemperature,
    required Duration brewTime,
    int? rating,
    List<String> flavorTags = const [],
    String? notes,
    double? tds,
    double? extractionYield,
  }) {
    return BrewLog(
      id: const Uuid().v4(),
      beanId: beanId,
      method: method,
      dose: dose,
      yield_: yield_,
      grindSize: grindSize,
      waterTemperature: waterTemperature,
      brewTime: brewTime,
      rating: rating,
      flavorTags: flavorTags,
      notes: notes,
      tds: tds,
      extractionYield: extractionYield,
      createdAt: DateTime.now(),
    );
  }

  BrewLog copyWith({
    String? id,
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
    double? tds,
    double? extractionYield,
    DateTime? createdAt,
  }) {
    return BrewLog(
      id: id ?? this.id,
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
      tds: tds ?? this.tds,
      extractionYield: extractionYield ?? this.extractionYield,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
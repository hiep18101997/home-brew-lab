import 'package:drift/drift.dart';
import '../../../../core/constants/brew_methods.dart';
import '../../../../domain/entities/brew_log.dart';
import '../../../../database.dart';

class BrewLogDto {
  final int id;
  final int? beanId;
  final BrewMethod method;
  final double dose;
  final double yieldColumn;
  final int grindSize;
  final int waterTemperature;
  final int brewTimeSeconds;
  final int? rating;
  final String? flavorTags;
  final String? notes;
  final double? tds;
  final double? extractionYield;
  final DateTime createdAt;

  BrewLogDto({
    required this.id,
    this.beanId,
    required this.method,
    required this.dose,
    required this.yieldColumn,
    required this.grindSize,
    required this.waterTemperature,
    required this.brewTimeSeconds,
    this.rating,
    this.flavorTags,
    this.notes,
    this.tds,
    this.extractionYield,
    required this.createdAt,
  });

  factory BrewLogDto.fromDrift(BrewLogsTableData row) {
    return BrewLogDto(
      id: row.id,
      beanId: row.beanId,
      method: BrewMethod.values.firstWhere((m) => m.name == row.method),
      dose: row.dose,
      yieldColumn: row.yieldColumn,
      grindSize: row.grindSize,
      waterTemperature: row.waterTemperature,
      brewTimeSeconds: row.brewTimeSeconds,
      rating: row.rating,
      flavorTags: row.flavorTags,
      notes: row.notes,
      tds: row.tds,
      extractionYield: row.extractionYield,
      createdAt: row.createdAt,
    );
  }

  BrewLog toEntity() {
    return BrewLog(
      id: id.toString(),
      beanId: beanId?.toString(),
      method: method,
      dose: dose,
      yield_: yieldColumn,
      grindSize: grindSize,
      waterTemperature: waterTemperature,
      brewTime: Duration(seconds: brewTimeSeconds),
      rating: rating,
      flavorTags: flavorTags?.split(',') ?? [],
      notes: notes,
      tds: tds,
      extractionYield: extractionYield,
      createdAt: createdAt,
    );
  }

  static BrewLogsTableCompanion fromEntity(BrewLog entity) {
    return BrewLogsTableCompanion.insert(
      beanId: Value(entity.beanId != null ? int.parse(entity.beanId!) : null),
      method: entity.method.name,
      dose: entity.dose,
      yieldColumn: entity.yield_,
      grindSize: entity.grindSize,
      waterTemperature: entity.waterTemperature,
      brewTimeSeconds: entity.brewTime.inSeconds,
      rating: Value(entity.rating),
      flavorTags: Value(entity.flavorTags.join(',')),
      notes: Value(entity.notes),
      tds: Value(entity.tds),
      extractionYield: Value(entity.extractionYield),
      createdAt: entity.createdAt,
    );
  }
}
import 'package:drift/drift.dart';
import '../../../../domain/entities/bean.dart';
import '../../../../database.dart';

class BeanDto {
  final int id;
  final String name;
  final String roaster;
  final String? origin;
  final String? variety;
  final String? process;
  final String? roastLevel;
  final DateTime? roastDate;
  final double weightRemaining;
  final double? weightInitial;
  final String? notes;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  BeanDto({
    required this.id,
    required this.name,
    required this.roaster,
    this.origin,
    this.variety,
    this.process,
    this.roastLevel,
    this.roastDate,
    required this.weightRemaining,
    this.weightInitial,
    this.notes,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BeanDto.fromDrift(BeansTableData row) {
    return BeanDto(
      id: row.id,
      name: row.name,
      roaster: row.roaster,
      origin: row.origin,
      variety: row.variety,
      process: row.process,
      roastLevel: row.roastLevel,
      roastDate: row.roastDate,
      weightRemaining: row.weightRemaining,
      weightInitial: row.weightInitial,
      notes: row.notes,
      imageUrl: row.imageUrl,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Bean toEntity() {
    return Bean(
      id: id.toString(), // Convert int to String
      name: name,
      roaster: roaster,
      origin: origin,
      variety: variety,
      process: process,
      roastLevel: roastLevel,
      roastDate: roastDate,
      weightRemaining: weightRemaining,
      weightInitial: weightInitial,
      notes: notes,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static BeansTableCompanion fromEntity(Bean entity) {
    return BeansTableCompanion.insert(
      name: entity.name,
      roaster: entity.roaster,
      origin: Value(entity.origin),
      variety: Value(entity.variety),
      process: Value(entity.process),
      roastLevel: Value(entity.roastLevel),
      roastDate: Value(entity.roastDate),
      weightRemaining: entity.weightRemaining,
      weightInitial: Value(entity.weightInitial),
      notes: Value(entity.notes),
      imageUrl: Value(entity.imageUrl),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
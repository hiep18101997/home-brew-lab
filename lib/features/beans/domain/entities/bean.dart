import 'package:uuid/uuid.dart';

class Bean {
  final String id;
  final String name;
  final String roaster;
  final String? origin;
  final String? variety;
  final String? process;
  final String? roastLevel;
  final DateTime? roastDate;
  final double weightRemaining; // grams
  final double? weightInitial;
  final String? notes;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Bean({
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

  factory Bean.create({
    required String name,
    required String roaster,
    String? origin,
    String? variety,
    String? process,
    String? roastLevel,
    DateTime? roastDate,
    required double weightRemaining,
    double? weightInitial,
    String? notes,
    String? imageUrl,
  }) {
    final now = DateTime.now();
    return Bean(
      id: const Uuid().v4(),
      name: name,
      roaster: roaster,
      origin: origin,
      variety: variety,
      process: process,
      roastLevel: roastLevel,
      roastDate: roastDate,
      weightRemaining: weightRemaining,
      weightInitial: weightInitial ?? weightRemaining,
      notes: notes,
      imageUrl: imageUrl,
      createdAt: now,
      updatedAt: now,
    );
  }

  Bean copyWith({
    String? id,
    String? name,
    String? roaster,
    String? origin,
    String? variety,
    String? process,
    String? roastLevel,
    DateTime? roastDate,
    double? weightRemaining,
    double? weightInitial,
    String? notes,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bean(
      id: id ?? this.id,
      name: name ?? this.name,
      roaster: roaster ?? this.roaster,
      origin: origin ?? this.origin,
      variety: variety ?? this.variety,
      process: process ?? this.process,
      roastLevel: roastLevel ?? this.roastLevel,
      roastDate: roastDate ?? this.roastDate,
      weightRemaining: weightRemaining ?? this.weightRemaining,
      weightInitial: weightInitial ?? this.weightInitial,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
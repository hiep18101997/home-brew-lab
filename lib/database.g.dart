// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BeansTableTable extends BeansTable
    with TableInfo<$BeansTableTable, BeansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roasterMeta = const VerificationMeta(
    'roaster',
  );
  @override
  late final GeneratedColumn<String> roaster = GeneratedColumn<String>(
    'roaster',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
    'origin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _varietyMeta = const VerificationMeta(
    'variety',
  );
  @override
  late final GeneratedColumn<String> variety = GeneratedColumn<String>(
    'variety',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _processMeta = const VerificationMeta(
    'process',
  );
  @override
  late final GeneratedColumn<String> process = GeneratedColumn<String>(
    'process',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roastLevelMeta = const VerificationMeta(
    'roastLevel',
  );
  @override
  late final GeneratedColumn<String> roastLevel = GeneratedColumn<String>(
    'roast_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roastDateMeta = const VerificationMeta(
    'roastDate',
  );
  @override
  late final GeneratedColumn<DateTime> roastDate = GeneratedColumn<DateTime>(
    'roast_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightRemainingMeta = const VerificationMeta(
    'weightRemaining',
  );
  @override
  late final GeneratedColumn<double> weightRemaining = GeneratedColumn<double>(
    'weight_remaining',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightInitialMeta = const VerificationMeta(
    'weightInitial',
  );
  @override
  late final GeneratedColumn<double> weightInitial = GeneratedColumn<double>(
    'weight_initial',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    roaster,
    origin,
    variety,
    process,
    roastLevel,
    roastDate,
    weightRemaining,
    weightInitial,
    notes,
    imageUrl,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beans_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BeansTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('roaster')) {
      context.handle(
        _roasterMeta,
        roaster.isAcceptableOrUnknown(data['roaster']!, _roasterMeta),
      );
    } else if (isInserting) {
      context.missing(_roasterMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(
        _originMeta,
        origin.isAcceptableOrUnknown(data['origin']!, _originMeta),
      );
    }
    if (data.containsKey('variety')) {
      context.handle(
        _varietyMeta,
        variety.isAcceptableOrUnknown(data['variety']!, _varietyMeta),
      );
    }
    if (data.containsKey('process')) {
      context.handle(
        _processMeta,
        process.isAcceptableOrUnknown(data['process']!, _processMeta),
      );
    }
    if (data.containsKey('roast_level')) {
      context.handle(
        _roastLevelMeta,
        roastLevel.isAcceptableOrUnknown(data['roast_level']!, _roastLevelMeta),
      );
    }
    if (data.containsKey('roast_date')) {
      context.handle(
        _roastDateMeta,
        roastDate.isAcceptableOrUnknown(data['roast_date']!, _roastDateMeta),
      );
    }
    if (data.containsKey('weight_remaining')) {
      context.handle(
        _weightRemainingMeta,
        weightRemaining.isAcceptableOrUnknown(
          data['weight_remaining']!,
          _weightRemainingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weightRemainingMeta);
    }
    if (data.containsKey('weight_initial')) {
      context.handle(
        _weightInitialMeta,
        weightInitial.isAcceptableOrUnknown(
          data['weight_initial']!,
          _weightInitialMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BeansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BeansTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      roaster: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}roaster'],
      )!,
      origin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin'],
      ),
      variety: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variety'],
      ),
      process: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}process'],
      ),
      roastLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}roast_level'],
      ),
      roastDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}roast_date'],
      ),
      weightRemaining: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_remaining'],
      )!,
      weightInitial: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_initial'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BeansTableTable createAlias(String alias) {
    return $BeansTableTable(attachedDatabase, alias);
  }
}

class BeansTableData extends DataClass implements Insertable<BeansTableData> {
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
  const BeansTableData({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['roaster'] = Variable<String>(roaster);
    if (!nullToAbsent || origin != null) {
      map['origin'] = Variable<String>(origin);
    }
    if (!nullToAbsent || variety != null) {
      map['variety'] = Variable<String>(variety);
    }
    if (!nullToAbsent || process != null) {
      map['process'] = Variable<String>(process);
    }
    if (!nullToAbsent || roastLevel != null) {
      map['roast_level'] = Variable<String>(roastLevel);
    }
    if (!nullToAbsent || roastDate != null) {
      map['roast_date'] = Variable<DateTime>(roastDate);
    }
    map['weight_remaining'] = Variable<double>(weightRemaining);
    if (!nullToAbsent || weightInitial != null) {
      map['weight_initial'] = Variable<double>(weightInitial);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BeansTableCompanion toCompanion(bool nullToAbsent) {
    return BeansTableCompanion(
      id: Value(id),
      name: Value(name),
      roaster: Value(roaster),
      origin: origin == null && nullToAbsent
          ? const Value.absent()
          : Value(origin),
      variety: variety == null && nullToAbsent
          ? const Value.absent()
          : Value(variety),
      process: process == null && nullToAbsent
          ? const Value.absent()
          : Value(process),
      roastLevel: roastLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(roastLevel),
      roastDate: roastDate == null && nullToAbsent
          ? const Value.absent()
          : Value(roastDate),
      weightRemaining: Value(weightRemaining),
      weightInitial: weightInitial == null && nullToAbsent
          ? const Value.absent()
          : Value(weightInitial),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BeansTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BeansTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      roaster: serializer.fromJson<String>(json['roaster']),
      origin: serializer.fromJson<String?>(json['origin']),
      variety: serializer.fromJson<String?>(json['variety']),
      process: serializer.fromJson<String?>(json['process']),
      roastLevel: serializer.fromJson<String?>(json['roastLevel']),
      roastDate: serializer.fromJson<DateTime?>(json['roastDate']),
      weightRemaining: serializer.fromJson<double>(json['weightRemaining']),
      weightInitial: serializer.fromJson<double?>(json['weightInitial']),
      notes: serializer.fromJson<String?>(json['notes']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'roaster': serializer.toJson<String>(roaster),
      'origin': serializer.toJson<String?>(origin),
      'variety': serializer.toJson<String?>(variety),
      'process': serializer.toJson<String?>(process),
      'roastLevel': serializer.toJson<String?>(roastLevel),
      'roastDate': serializer.toJson<DateTime?>(roastDate),
      'weightRemaining': serializer.toJson<double>(weightRemaining),
      'weightInitial': serializer.toJson<double?>(weightInitial),
      'notes': serializer.toJson<String?>(notes),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BeansTableData copyWith({
    int? id,
    String? name,
    String? roaster,
    Value<String?> origin = const Value.absent(),
    Value<String?> variety = const Value.absent(),
    Value<String?> process = const Value.absent(),
    Value<String?> roastLevel = const Value.absent(),
    Value<DateTime?> roastDate = const Value.absent(),
    double? weightRemaining,
    Value<double?> weightInitial = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BeansTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    roaster: roaster ?? this.roaster,
    origin: origin.present ? origin.value : this.origin,
    variety: variety.present ? variety.value : this.variety,
    process: process.present ? process.value : this.process,
    roastLevel: roastLevel.present ? roastLevel.value : this.roastLevel,
    roastDate: roastDate.present ? roastDate.value : this.roastDate,
    weightRemaining: weightRemaining ?? this.weightRemaining,
    weightInitial: weightInitial.present
        ? weightInitial.value
        : this.weightInitial,
    notes: notes.present ? notes.value : this.notes,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BeansTableData copyWithCompanion(BeansTableCompanion data) {
    return BeansTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      roaster: data.roaster.present ? data.roaster.value : this.roaster,
      origin: data.origin.present ? data.origin.value : this.origin,
      variety: data.variety.present ? data.variety.value : this.variety,
      process: data.process.present ? data.process.value : this.process,
      roastLevel: data.roastLevel.present
          ? data.roastLevel.value
          : this.roastLevel,
      roastDate: data.roastDate.present ? data.roastDate.value : this.roastDate,
      weightRemaining: data.weightRemaining.present
          ? data.weightRemaining.value
          : this.weightRemaining,
      weightInitial: data.weightInitial.present
          ? data.weightInitial.value
          : this.weightInitial,
      notes: data.notes.present ? data.notes.value : this.notes,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BeansTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('roaster: $roaster, ')
          ..write('origin: $origin, ')
          ..write('variety: $variety, ')
          ..write('process: $process, ')
          ..write('roastLevel: $roastLevel, ')
          ..write('roastDate: $roastDate, ')
          ..write('weightRemaining: $weightRemaining, ')
          ..write('weightInitial: $weightInitial, ')
          ..write('notes: $notes, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    roaster,
    origin,
    variety,
    process,
    roastLevel,
    roastDate,
    weightRemaining,
    weightInitial,
    notes,
    imageUrl,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BeansTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.roaster == this.roaster &&
          other.origin == this.origin &&
          other.variety == this.variety &&
          other.process == this.process &&
          other.roastLevel == this.roastLevel &&
          other.roastDate == this.roastDate &&
          other.weightRemaining == this.weightRemaining &&
          other.weightInitial == this.weightInitial &&
          other.notes == this.notes &&
          other.imageUrl == this.imageUrl &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BeansTableCompanion extends UpdateCompanion<BeansTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> roaster;
  final Value<String?> origin;
  final Value<String?> variety;
  final Value<String?> process;
  final Value<String?> roastLevel;
  final Value<DateTime?> roastDate;
  final Value<double> weightRemaining;
  final Value<double?> weightInitial;
  final Value<String?> notes;
  final Value<String?> imageUrl;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BeansTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.roaster = const Value.absent(),
    this.origin = const Value.absent(),
    this.variety = const Value.absent(),
    this.process = const Value.absent(),
    this.roastLevel = const Value.absent(),
    this.roastDate = const Value.absent(),
    this.weightRemaining = const Value.absent(),
    this.weightInitial = const Value.absent(),
    this.notes = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BeansTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String roaster,
    this.origin = const Value.absent(),
    this.variety = const Value.absent(),
    this.process = const Value.absent(),
    this.roastLevel = const Value.absent(),
    this.roastDate = const Value.absent(),
    required double weightRemaining,
    this.weightInitial = const Value.absent(),
    this.notes = const Value.absent(),
    this.imageUrl = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       roaster = Value(roaster),
       weightRemaining = Value(weightRemaining),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BeansTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? roaster,
    Expression<String>? origin,
    Expression<String>? variety,
    Expression<String>? process,
    Expression<String>? roastLevel,
    Expression<DateTime>? roastDate,
    Expression<double>? weightRemaining,
    Expression<double>? weightInitial,
    Expression<String>? notes,
    Expression<String>? imageUrl,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (roaster != null) 'roaster': roaster,
      if (origin != null) 'origin': origin,
      if (variety != null) 'variety': variety,
      if (process != null) 'process': process,
      if (roastLevel != null) 'roast_level': roastLevel,
      if (roastDate != null) 'roast_date': roastDate,
      if (weightRemaining != null) 'weight_remaining': weightRemaining,
      if (weightInitial != null) 'weight_initial': weightInitial,
      if (notes != null) 'notes': notes,
      if (imageUrl != null) 'image_url': imageUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BeansTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? roaster,
    Value<String?>? origin,
    Value<String?>? variety,
    Value<String?>? process,
    Value<String?>? roastLevel,
    Value<DateTime?>? roastDate,
    Value<double>? weightRemaining,
    Value<double?>? weightInitial,
    Value<String?>? notes,
    Value<String?>? imageUrl,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BeansTableCompanion(
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
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (roaster.present) {
      map['roaster'] = Variable<String>(roaster.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (variety.present) {
      map['variety'] = Variable<String>(variety.value);
    }
    if (process.present) {
      map['process'] = Variable<String>(process.value);
    }
    if (roastLevel.present) {
      map['roast_level'] = Variable<String>(roastLevel.value);
    }
    if (roastDate.present) {
      map['roast_date'] = Variable<DateTime>(roastDate.value);
    }
    if (weightRemaining.present) {
      map['weight_remaining'] = Variable<double>(weightRemaining.value);
    }
    if (weightInitial.present) {
      map['weight_initial'] = Variable<double>(weightInitial.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeansTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('roaster: $roaster, ')
          ..write('origin: $origin, ')
          ..write('variety: $variety, ')
          ..write('process: $process, ')
          ..write('roastLevel: $roastLevel, ')
          ..write('roastDate: $roastDate, ')
          ..write('weightRemaining: $weightRemaining, ')
          ..write('weightInitial: $weightInitial, ')
          ..write('notes: $notes, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BrewLogsTableTable extends BrewLogsTable
    with TableInfo<$BrewLogsTableTable, BrewLogsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrewLogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _beanIdMeta = const VerificationMeta('beanId');
  @override
  late final GeneratedColumn<int> beanId = GeneratedColumn<int>(
    'bean_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<double> dose = GeneratedColumn<double>(
    'dose',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yieldColumnMeta = const VerificationMeta(
    'yieldColumn',
  );
  @override
  late final GeneratedColumn<double> yieldColumn = GeneratedColumn<double>(
    'yield_column',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grindSizeMeta = const VerificationMeta(
    'grindSize',
  );
  @override
  late final GeneratedColumn<int> grindSize = GeneratedColumn<int>(
    'grind_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterTemperatureMeta = const VerificationMeta(
    'waterTemperature',
  );
  @override
  late final GeneratedColumn<int> waterTemperature = GeneratedColumn<int>(
    'water_temperature',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brewTimeSecondsMeta = const VerificationMeta(
    'brewTimeSeconds',
  );
  @override
  late final GeneratedColumn<int> brewTimeSeconds = GeneratedColumn<int>(
    'brew_time_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flavorTagsMeta = const VerificationMeta(
    'flavorTags',
  );
  @override
  late final GeneratedColumn<String> flavorTags = GeneratedColumn<String>(
    'flavor_tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tdsMeta = const VerificationMeta('tds');
  @override
  late final GeneratedColumn<double> tds = GeneratedColumn<double>(
    'tds',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _extractionYieldMeta = const VerificationMeta(
    'extractionYield',
  );
  @override
  late final GeneratedColumn<double> extractionYield = GeneratedColumn<double>(
    'extraction_yield',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    beanId,
    method,
    dose,
    yieldColumn,
    grindSize,
    waterTemperature,
    brewTimeSeconds,
    rating,
    flavorTags,
    notes,
    tds,
    extractionYield,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brew_logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrewLogsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bean_id')) {
      context.handle(
        _beanIdMeta,
        beanId.isAcceptableOrUnknown(data['bean_id']!, _beanIdMeta),
      );
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('yield_column')) {
      context.handle(
        _yieldColumnMeta,
        yieldColumn.isAcceptableOrUnknown(
          data['yield_column']!,
          _yieldColumnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yieldColumnMeta);
    }
    if (data.containsKey('grind_size')) {
      context.handle(
        _grindSizeMeta,
        grindSize.isAcceptableOrUnknown(data['grind_size']!, _grindSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_grindSizeMeta);
    }
    if (data.containsKey('water_temperature')) {
      context.handle(
        _waterTemperatureMeta,
        waterTemperature.isAcceptableOrUnknown(
          data['water_temperature']!,
          _waterTemperatureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_waterTemperatureMeta);
    }
    if (data.containsKey('brew_time_seconds')) {
      context.handle(
        _brewTimeSecondsMeta,
        brewTimeSeconds.isAcceptableOrUnknown(
          data['brew_time_seconds']!,
          _brewTimeSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_brewTimeSecondsMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('flavor_tags')) {
      context.handle(
        _flavorTagsMeta,
        flavorTags.isAcceptableOrUnknown(data['flavor_tags']!, _flavorTagsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tds')) {
      context.handle(
        _tdsMeta,
        tds.isAcceptableOrUnknown(data['tds']!, _tdsMeta),
      );
    }
    if (data.containsKey('extraction_yield')) {
      context.handle(
        _extractionYieldMeta,
        extractionYield.isAcceptableOrUnknown(
          data['extraction_yield']!,
          _extractionYieldMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrewLogsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrewLogsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      beanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bean_id'],
      ),
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dose'],
      )!,
      yieldColumn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}yield_column'],
      )!,
      grindSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grind_size'],
      )!,
      waterTemperature: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_temperature'],
      )!,
      brewTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brew_time_seconds'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      flavorTags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flavor_tags'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tds: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tds'],
      ),
      extractionYield: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}extraction_yield'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BrewLogsTableTable createAlias(String alias) {
    return $BrewLogsTableTable(attachedDatabase, alias);
  }
}

class BrewLogsTableData extends DataClass
    implements Insertable<BrewLogsTableData> {
  final int id;
  final int? beanId;
  final String method;
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
  const BrewLogsTableData({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || beanId != null) {
      map['bean_id'] = Variable<int>(beanId);
    }
    map['method'] = Variable<String>(method);
    map['dose'] = Variable<double>(dose);
    map['yield_column'] = Variable<double>(yieldColumn);
    map['grind_size'] = Variable<int>(grindSize);
    map['water_temperature'] = Variable<int>(waterTemperature);
    map['brew_time_seconds'] = Variable<int>(brewTimeSeconds);
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || flavorTags != null) {
      map['flavor_tags'] = Variable<String>(flavorTags);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || tds != null) {
      map['tds'] = Variable<double>(tds);
    }
    if (!nullToAbsent || extractionYield != null) {
      map['extraction_yield'] = Variable<double>(extractionYield);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BrewLogsTableCompanion toCompanion(bool nullToAbsent) {
    return BrewLogsTableCompanion(
      id: Value(id),
      beanId: beanId == null && nullToAbsent
          ? const Value.absent()
          : Value(beanId),
      method: Value(method),
      dose: Value(dose),
      yieldColumn: Value(yieldColumn),
      grindSize: Value(grindSize),
      waterTemperature: Value(waterTemperature),
      brewTimeSeconds: Value(brewTimeSeconds),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      flavorTags: flavorTags == null && nullToAbsent
          ? const Value.absent()
          : Value(flavorTags),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tds: tds == null && nullToAbsent ? const Value.absent() : Value(tds),
      extractionYield: extractionYield == null && nullToAbsent
          ? const Value.absent()
          : Value(extractionYield),
      createdAt: Value(createdAt),
    );
  }

  factory BrewLogsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrewLogsTableData(
      id: serializer.fromJson<int>(json['id']),
      beanId: serializer.fromJson<int?>(json['beanId']),
      method: serializer.fromJson<String>(json['method']),
      dose: serializer.fromJson<double>(json['dose']),
      yieldColumn: serializer.fromJson<double>(json['yieldColumn']),
      grindSize: serializer.fromJson<int>(json['grindSize']),
      waterTemperature: serializer.fromJson<int>(json['waterTemperature']),
      brewTimeSeconds: serializer.fromJson<int>(json['brewTimeSeconds']),
      rating: serializer.fromJson<int?>(json['rating']),
      flavorTags: serializer.fromJson<String?>(json['flavorTags']),
      notes: serializer.fromJson<String?>(json['notes']),
      tds: serializer.fromJson<double?>(json['tds']),
      extractionYield: serializer.fromJson<double?>(json['extractionYield']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'beanId': serializer.toJson<int?>(beanId),
      'method': serializer.toJson<String>(method),
      'dose': serializer.toJson<double>(dose),
      'yieldColumn': serializer.toJson<double>(yieldColumn),
      'grindSize': serializer.toJson<int>(grindSize),
      'waterTemperature': serializer.toJson<int>(waterTemperature),
      'brewTimeSeconds': serializer.toJson<int>(brewTimeSeconds),
      'rating': serializer.toJson<int?>(rating),
      'flavorTags': serializer.toJson<String?>(flavorTags),
      'notes': serializer.toJson<String?>(notes),
      'tds': serializer.toJson<double?>(tds),
      'extractionYield': serializer.toJson<double?>(extractionYield),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BrewLogsTableData copyWith({
    int? id,
    Value<int?> beanId = const Value.absent(),
    String? method,
    double? dose,
    double? yieldColumn,
    int? grindSize,
    int? waterTemperature,
    int? brewTimeSeconds,
    Value<int?> rating = const Value.absent(),
    Value<String?> flavorTags = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<double?> tds = const Value.absent(),
    Value<double?> extractionYield = const Value.absent(),
    DateTime? createdAt,
  }) => BrewLogsTableData(
    id: id ?? this.id,
    beanId: beanId.present ? beanId.value : this.beanId,
    method: method ?? this.method,
    dose: dose ?? this.dose,
    yieldColumn: yieldColumn ?? this.yieldColumn,
    grindSize: grindSize ?? this.grindSize,
    waterTemperature: waterTemperature ?? this.waterTemperature,
    brewTimeSeconds: brewTimeSeconds ?? this.brewTimeSeconds,
    rating: rating.present ? rating.value : this.rating,
    flavorTags: flavorTags.present ? flavorTags.value : this.flavorTags,
    notes: notes.present ? notes.value : this.notes,
    tds: tds.present ? tds.value : this.tds,
    extractionYield: extractionYield.present
        ? extractionYield.value
        : this.extractionYield,
    createdAt: createdAt ?? this.createdAt,
  );
  BrewLogsTableData copyWithCompanion(BrewLogsTableCompanion data) {
    return BrewLogsTableData(
      id: data.id.present ? data.id.value : this.id,
      beanId: data.beanId.present ? data.beanId.value : this.beanId,
      method: data.method.present ? data.method.value : this.method,
      dose: data.dose.present ? data.dose.value : this.dose,
      yieldColumn: data.yieldColumn.present
          ? data.yieldColumn.value
          : this.yieldColumn,
      grindSize: data.grindSize.present ? data.grindSize.value : this.grindSize,
      waterTemperature: data.waterTemperature.present
          ? data.waterTemperature.value
          : this.waterTemperature,
      brewTimeSeconds: data.brewTimeSeconds.present
          ? data.brewTimeSeconds.value
          : this.brewTimeSeconds,
      rating: data.rating.present ? data.rating.value : this.rating,
      flavorTags: data.flavorTags.present
          ? data.flavorTags.value
          : this.flavorTags,
      notes: data.notes.present ? data.notes.value : this.notes,
      tds: data.tds.present ? data.tds.value : this.tds,
      extractionYield: data.extractionYield.present
          ? data.extractionYield.value
          : this.extractionYield,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrewLogsTableData(')
          ..write('id: $id, ')
          ..write('beanId: $beanId, ')
          ..write('method: $method, ')
          ..write('dose: $dose, ')
          ..write('yieldColumn: $yieldColumn, ')
          ..write('grindSize: $grindSize, ')
          ..write('waterTemperature: $waterTemperature, ')
          ..write('brewTimeSeconds: $brewTimeSeconds, ')
          ..write('rating: $rating, ')
          ..write('flavorTags: $flavorTags, ')
          ..write('notes: $notes, ')
          ..write('tds: $tds, ')
          ..write('extractionYield: $extractionYield, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    beanId,
    method,
    dose,
    yieldColumn,
    grindSize,
    waterTemperature,
    brewTimeSeconds,
    rating,
    flavorTags,
    notes,
    tds,
    extractionYield,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrewLogsTableData &&
          other.id == this.id &&
          other.beanId == this.beanId &&
          other.method == this.method &&
          other.dose == this.dose &&
          other.yieldColumn == this.yieldColumn &&
          other.grindSize == this.grindSize &&
          other.waterTemperature == this.waterTemperature &&
          other.brewTimeSeconds == this.brewTimeSeconds &&
          other.rating == this.rating &&
          other.flavorTags == this.flavorTags &&
          other.notes == this.notes &&
          other.tds == this.tds &&
          other.extractionYield == this.extractionYield &&
          other.createdAt == this.createdAt);
}

class BrewLogsTableCompanion extends UpdateCompanion<BrewLogsTableData> {
  final Value<int> id;
  final Value<int?> beanId;
  final Value<String> method;
  final Value<double> dose;
  final Value<double> yieldColumn;
  final Value<int> grindSize;
  final Value<int> waterTemperature;
  final Value<int> brewTimeSeconds;
  final Value<int?> rating;
  final Value<String?> flavorTags;
  final Value<String?> notes;
  final Value<double?> tds;
  final Value<double?> extractionYield;
  final Value<DateTime> createdAt;
  const BrewLogsTableCompanion({
    this.id = const Value.absent(),
    this.beanId = const Value.absent(),
    this.method = const Value.absent(),
    this.dose = const Value.absent(),
    this.yieldColumn = const Value.absent(),
    this.grindSize = const Value.absent(),
    this.waterTemperature = const Value.absent(),
    this.brewTimeSeconds = const Value.absent(),
    this.rating = const Value.absent(),
    this.flavorTags = const Value.absent(),
    this.notes = const Value.absent(),
    this.tds = const Value.absent(),
    this.extractionYield = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BrewLogsTableCompanion.insert({
    this.id = const Value.absent(),
    this.beanId = const Value.absent(),
    required String method,
    required double dose,
    required double yieldColumn,
    required int grindSize,
    required int waterTemperature,
    required int brewTimeSeconds,
    this.rating = const Value.absent(),
    this.flavorTags = const Value.absent(),
    this.notes = const Value.absent(),
    this.tds = const Value.absent(),
    this.extractionYield = const Value.absent(),
    required DateTime createdAt,
  }) : method = Value(method),
       dose = Value(dose),
       yieldColumn = Value(yieldColumn),
       grindSize = Value(grindSize),
       waterTemperature = Value(waterTemperature),
       brewTimeSeconds = Value(brewTimeSeconds),
       createdAt = Value(createdAt);
  static Insertable<BrewLogsTableData> custom({
    Expression<int>? id,
    Expression<int>? beanId,
    Expression<String>? method,
    Expression<double>? dose,
    Expression<double>? yieldColumn,
    Expression<int>? grindSize,
    Expression<int>? waterTemperature,
    Expression<int>? brewTimeSeconds,
    Expression<int>? rating,
    Expression<String>? flavorTags,
    Expression<String>? notes,
    Expression<double>? tds,
    Expression<double>? extractionYield,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (beanId != null) 'bean_id': beanId,
      if (method != null) 'method': method,
      if (dose != null) 'dose': dose,
      if (yieldColumn != null) 'yield_column': yieldColumn,
      if (grindSize != null) 'grind_size': grindSize,
      if (waterTemperature != null) 'water_temperature': waterTemperature,
      if (brewTimeSeconds != null) 'brew_time_seconds': brewTimeSeconds,
      if (rating != null) 'rating': rating,
      if (flavorTags != null) 'flavor_tags': flavorTags,
      if (notes != null) 'notes': notes,
      if (tds != null) 'tds': tds,
      if (extractionYield != null) 'extraction_yield': extractionYield,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BrewLogsTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? beanId,
    Value<String>? method,
    Value<double>? dose,
    Value<double>? yieldColumn,
    Value<int>? grindSize,
    Value<int>? waterTemperature,
    Value<int>? brewTimeSeconds,
    Value<int?>? rating,
    Value<String?>? flavorTags,
    Value<String?>? notes,
    Value<double?>? tds,
    Value<double?>? extractionYield,
    Value<DateTime>? createdAt,
  }) {
    return BrewLogsTableCompanion(
      id: id ?? this.id,
      beanId: beanId ?? this.beanId,
      method: method ?? this.method,
      dose: dose ?? this.dose,
      yieldColumn: yieldColumn ?? this.yieldColumn,
      grindSize: grindSize ?? this.grindSize,
      waterTemperature: waterTemperature ?? this.waterTemperature,
      brewTimeSeconds: brewTimeSeconds ?? this.brewTimeSeconds,
      rating: rating ?? this.rating,
      flavorTags: flavorTags ?? this.flavorTags,
      notes: notes ?? this.notes,
      tds: tds ?? this.tds,
      extractionYield: extractionYield ?? this.extractionYield,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (beanId.present) {
      map['bean_id'] = Variable<int>(beanId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (dose.present) {
      map['dose'] = Variable<double>(dose.value);
    }
    if (yieldColumn.present) {
      map['yield_column'] = Variable<double>(yieldColumn.value);
    }
    if (grindSize.present) {
      map['grind_size'] = Variable<int>(grindSize.value);
    }
    if (waterTemperature.present) {
      map['water_temperature'] = Variable<int>(waterTemperature.value);
    }
    if (brewTimeSeconds.present) {
      map['brew_time_seconds'] = Variable<int>(brewTimeSeconds.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (flavorTags.present) {
      map['flavor_tags'] = Variable<String>(flavorTags.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tds.present) {
      map['tds'] = Variable<double>(tds.value);
    }
    if (extractionYield.present) {
      map['extraction_yield'] = Variable<double>(extractionYield.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrewLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('beanId: $beanId, ')
          ..write('method: $method, ')
          ..write('dose: $dose, ')
          ..write('yieldColumn: $yieldColumn, ')
          ..write('grindSize: $grindSize, ')
          ..write('waterTemperature: $waterTemperature, ')
          ..write('brewTimeSeconds: $brewTimeSeconds, ')
          ..write('rating: $rating, ')
          ..write('flavorTags: $flavorTags, ')
          ..write('notes: $notes, ')
          ..write('tds: $tds, ')
          ..write('extractionYield: $extractionYield, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BeansTableTable beansTable = $BeansTableTable(this);
  late final $BrewLogsTableTable brewLogsTable = $BrewLogsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    beansTable,
    brewLogsTable,
  ];
}

typedef $$BeansTableTableCreateCompanionBuilder =
    BeansTableCompanion Function({
      Value<int> id,
      required String name,
      required String roaster,
      Value<String?> origin,
      Value<String?> variety,
      Value<String?> process,
      Value<String?> roastLevel,
      Value<DateTime?> roastDate,
      required double weightRemaining,
      Value<double?> weightInitial,
      Value<String?> notes,
      Value<String?> imageUrl,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$BeansTableTableUpdateCompanionBuilder =
    BeansTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> roaster,
      Value<String?> origin,
      Value<String?> variety,
      Value<String?> process,
      Value<String?> roastLevel,
      Value<DateTime?> roastDate,
      Value<double> weightRemaining,
      Value<double?> weightInitial,
      Value<String?> notes,
      Value<String?> imageUrl,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$BeansTableTableFilterComposer
    extends Composer<_$AppDatabase, $BeansTableTable> {
  $$BeansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roaster => $composableBuilder(
    column: $table.roaster,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variety => $composableBuilder(
    column: $table.variety,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get process => $composableBuilder(
    column: $table.process,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roastLevel => $composableBuilder(
    column: $table.roastLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get roastDate => $composableBuilder(
    column: $table.roastDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightRemaining => $composableBuilder(
    column: $table.weightRemaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightInitial => $composableBuilder(
    column: $table.weightInitial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BeansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BeansTableTable> {
  $$BeansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roaster => $composableBuilder(
    column: $table.roaster,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variety => $composableBuilder(
    column: $table.variety,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get process => $composableBuilder(
    column: $table.process,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roastLevel => $composableBuilder(
    column: $table.roastLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get roastDate => $composableBuilder(
    column: $table.roastDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightRemaining => $composableBuilder(
    column: $table.weightRemaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightInitial => $composableBuilder(
    column: $table.weightInitial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BeansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BeansTableTable> {
  $$BeansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get roaster =>
      $composableBuilder(column: $table.roaster, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get variety =>
      $composableBuilder(column: $table.variety, builder: (column) => column);

  GeneratedColumn<String> get process =>
      $composableBuilder(column: $table.process, builder: (column) => column);

  GeneratedColumn<String> get roastLevel => $composableBuilder(
    column: $table.roastLevel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get roastDate =>
      $composableBuilder(column: $table.roastDate, builder: (column) => column);

  GeneratedColumn<double> get weightRemaining => $composableBuilder(
    column: $table.weightRemaining,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weightInitial => $composableBuilder(
    column: $table.weightInitial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BeansTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BeansTableTable,
          BeansTableData,
          $$BeansTableTableFilterComposer,
          $$BeansTableTableOrderingComposer,
          $$BeansTableTableAnnotationComposer,
          $$BeansTableTableCreateCompanionBuilder,
          $$BeansTableTableUpdateCompanionBuilder,
          (
            BeansTableData,
            BaseReferences<_$AppDatabase, $BeansTableTable, BeansTableData>,
          ),
          BeansTableData,
          PrefetchHooks Function()
        > {
  $$BeansTableTableTableManager(_$AppDatabase db, $BeansTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BeansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BeansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BeansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> roaster = const Value.absent(),
                Value<String?> origin = const Value.absent(),
                Value<String?> variety = const Value.absent(),
                Value<String?> process = const Value.absent(),
                Value<String?> roastLevel = const Value.absent(),
                Value<DateTime?> roastDate = const Value.absent(),
                Value<double> weightRemaining = const Value.absent(),
                Value<double?> weightInitial = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BeansTableCompanion(
                id: id,
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
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String roaster,
                Value<String?> origin = const Value.absent(),
                Value<String?> variety = const Value.absent(),
                Value<String?> process = const Value.absent(),
                Value<String?> roastLevel = const Value.absent(),
                Value<DateTime?> roastDate = const Value.absent(),
                required double weightRemaining,
                Value<double?> weightInitial = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => BeansTableCompanion.insert(
                id: id,
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
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BeansTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BeansTableTable,
      BeansTableData,
      $$BeansTableTableFilterComposer,
      $$BeansTableTableOrderingComposer,
      $$BeansTableTableAnnotationComposer,
      $$BeansTableTableCreateCompanionBuilder,
      $$BeansTableTableUpdateCompanionBuilder,
      (
        BeansTableData,
        BaseReferences<_$AppDatabase, $BeansTableTable, BeansTableData>,
      ),
      BeansTableData,
      PrefetchHooks Function()
    >;
typedef $$BrewLogsTableTableCreateCompanionBuilder =
    BrewLogsTableCompanion Function({
      Value<int> id,
      Value<int?> beanId,
      required String method,
      required double dose,
      required double yieldColumn,
      required int grindSize,
      required int waterTemperature,
      required int brewTimeSeconds,
      Value<int?> rating,
      Value<String?> flavorTags,
      Value<String?> notes,
      Value<double?> tds,
      Value<double?> extractionYield,
      required DateTime createdAt,
    });
typedef $$BrewLogsTableTableUpdateCompanionBuilder =
    BrewLogsTableCompanion Function({
      Value<int> id,
      Value<int?> beanId,
      Value<String> method,
      Value<double> dose,
      Value<double> yieldColumn,
      Value<int> grindSize,
      Value<int> waterTemperature,
      Value<int> brewTimeSeconds,
      Value<int?> rating,
      Value<String?> flavorTags,
      Value<String?> notes,
      Value<double?> tds,
      Value<double?> extractionYield,
      Value<DateTime> createdAt,
    });

class $$BrewLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BrewLogsTableTable> {
  $$BrewLogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get beanId => $composableBuilder(
    column: $table.beanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get yieldColumn => $composableBuilder(
    column: $table.yieldColumn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grindSize => $composableBuilder(
    column: $table.grindSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterTemperature => $composableBuilder(
    column: $table.waterTemperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get brewTimeSeconds => $composableBuilder(
    column: $table.brewTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flavorTags => $composableBuilder(
    column: $table.flavorTags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tds => $composableBuilder(
    column: $table.tds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get extractionYield => $composableBuilder(
    column: $table.extractionYield,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrewLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BrewLogsTableTable> {
  $$BrewLogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get beanId => $composableBuilder(
    column: $table.beanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get yieldColumn => $composableBuilder(
    column: $table.yieldColumn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grindSize => $composableBuilder(
    column: $table.grindSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterTemperature => $composableBuilder(
    column: $table.waterTemperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get brewTimeSeconds => $composableBuilder(
    column: $table.brewTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flavorTags => $composableBuilder(
    column: $table.flavorTags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tds => $composableBuilder(
    column: $table.tds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get extractionYield => $composableBuilder(
    column: $table.extractionYield,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrewLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrewLogsTableTable> {
  $$BrewLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get beanId =>
      $composableBuilder(column: $table.beanId, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<double> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<double> get yieldColumn => $composableBuilder(
    column: $table.yieldColumn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grindSize =>
      $composableBuilder(column: $table.grindSize, builder: (column) => column);

  GeneratedColumn<int> get waterTemperature => $composableBuilder(
    column: $table.waterTemperature,
    builder: (column) => column,
  );

  GeneratedColumn<int> get brewTimeSeconds => $composableBuilder(
    column: $table.brewTimeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get flavorTags => $composableBuilder(
    column: $table.flavorTags,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get tds =>
      $composableBuilder(column: $table.tds, builder: (column) => column);

  GeneratedColumn<double> get extractionYield => $composableBuilder(
    column: $table.extractionYield,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BrewLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrewLogsTableTable,
          BrewLogsTableData,
          $$BrewLogsTableTableFilterComposer,
          $$BrewLogsTableTableOrderingComposer,
          $$BrewLogsTableTableAnnotationComposer,
          $$BrewLogsTableTableCreateCompanionBuilder,
          $$BrewLogsTableTableUpdateCompanionBuilder,
          (
            BrewLogsTableData,
            BaseReferences<
              _$AppDatabase,
              $BrewLogsTableTable,
              BrewLogsTableData
            >,
          ),
          BrewLogsTableData,
          PrefetchHooks Function()
        > {
  $$BrewLogsTableTableTableManager(_$AppDatabase db, $BrewLogsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrewLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrewLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrewLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> beanId = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<double> dose = const Value.absent(),
                Value<double> yieldColumn = const Value.absent(),
                Value<int> grindSize = const Value.absent(),
                Value<int> waterTemperature = const Value.absent(),
                Value<int> brewTimeSeconds = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> flavorTags = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> tds = const Value.absent(),
                Value<double?> extractionYield = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BrewLogsTableCompanion(
                id: id,
                beanId: beanId,
                method: method,
                dose: dose,
                yieldColumn: yieldColumn,
                grindSize: grindSize,
                waterTemperature: waterTemperature,
                brewTimeSeconds: brewTimeSeconds,
                rating: rating,
                flavorTags: flavorTags,
                notes: notes,
                tds: tds,
                extractionYield: extractionYield,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> beanId = const Value.absent(),
                required String method,
                required double dose,
                required double yieldColumn,
                required int grindSize,
                required int waterTemperature,
                required int brewTimeSeconds,
                Value<int?> rating = const Value.absent(),
                Value<String?> flavorTags = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> tds = const Value.absent(),
                Value<double?> extractionYield = const Value.absent(),
                required DateTime createdAt,
              }) => BrewLogsTableCompanion.insert(
                id: id,
                beanId: beanId,
                method: method,
                dose: dose,
                yieldColumn: yieldColumn,
                grindSize: grindSize,
                waterTemperature: waterTemperature,
                brewTimeSeconds: brewTimeSeconds,
                rating: rating,
                flavorTags: flavorTags,
                notes: notes,
                tds: tds,
                extractionYield: extractionYield,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrewLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrewLogsTableTable,
      BrewLogsTableData,
      $$BrewLogsTableTableFilterComposer,
      $$BrewLogsTableTableOrderingComposer,
      $$BrewLogsTableTableAnnotationComposer,
      $$BrewLogsTableTableCreateCompanionBuilder,
      $$BrewLogsTableTableUpdateCompanionBuilder,
      (
        BrewLogsTableData,
        BaseReferences<_$AppDatabase, $BrewLogsTableTable, BrewLogsTableData>,
      ),
      BrewLogsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BeansTableTableTableManager get beansTable =>
      $$BeansTableTableTableManager(_db, _db.beansTable);
  $$BrewLogsTableTableTableManager get brewLogsTable =>
      $$BrewLogsTableTableTableManager(_db, _db.brewLogsTable);
}

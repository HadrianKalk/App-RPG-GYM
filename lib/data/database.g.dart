// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RoutinesTable extends Routines
    with TableInfo<$RoutinesTable, RoutineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  List<GeneratedColumn> get $columns => [id, name, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
  RoutineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
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
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class RoutineRow extends DataClass implements Insertable<RoutineRow> {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoutineRow({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoutineRow copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RoutineRow(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoutineRow copyWithCompanion(RoutinesCompanion data) {
    return RoutineRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutinesCompanion extends UpdateCompanion<RoutineRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RoutineRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MuscleGroup, String> muscleGroup =
      GeneratedColumn<String>(
        'muscle_group',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MuscleGroup>($ExercisesTable.$convertermuscleGroup);
  @override
  late final GeneratedColumnWithTypeConverter<Equipment, String> equipment =
      GeneratedColumn<String>(
        'equipment',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Equipment>($ExercisesTable.$converterequipment);
  @override
  late final GeneratedColumnWithTypeConverter<Attribute, String> attribute =
      GeneratedColumn<String>(
        'attribute',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Attribute>($ExercisesTable.$converterattribute);
  @override
  late final GeneratedColumnWithTypeConverter<SetTracking, String> tracking =
      GeneratedColumn<String>(
        'tracking',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SetTracking.weightReps.name),
      ).withConverter<SetTracking>($ExercisesTable.$convertertracking);
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    muscleGroup,
    equipment,
    attribute,
    tracking,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      muscleGroup: $ExercisesTable.$convertermuscleGroup.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}muscle_group'],
        )!,
      ),
      equipment: $ExercisesTable.$converterequipment.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}equipment'],
        )!,
      ),
      attribute: $ExercisesTable.$converterattribute.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}attribute'],
        )!,
      ),
      tracking: $ExercisesTable.$convertertracking.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tracking'],
        )!,
      ),
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MuscleGroup, String, String> $convertermuscleGroup =
      const EnumNameConverter<MuscleGroup>(MuscleGroup.values);
  static JsonTypeConverter2<Equipment, String, String> $converterequipment =
      const EnumNameConverter<Equipment>(Equipment.values);
  static JsonTypeConverter2<Attribute, String, String> $converterattribute =
      const EnumNameConverter<Attribute>(Attribute.values);
  static JsonTypeConverter2<SetTracking, String, String> $convertertracking =
      const EnumNameConverter<SetTracking>(SetTracking.values);
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final String name;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final Attribute attribute;
  final SetTracking tracking;
  final bool isCustom;
  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.attribute,
    required this.tracking,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['muscle_group'] = Variable<String>(
        $ExercisesTable.$convertermuscleGroup.toSql(muscleGroup),
      );
    }
    {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipment.toSql(equipment),
      );
    }
    {
      map['attribute'] = Variable<String>(
        $ExercisesTable.$converterattribute.toSql(attribute),
      );
    }
    {
      map['tracking'] = Variable<String>(
        $ExercisesTable.$convertertracking.toSql(tracking),
      );
    }
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      muscleGroup: Value(muscleGroup),
      equipment: Value(equipment),
      attribute: Value(attribute),
      tracking: Value(tracking),
      isCustom: Value(isCustom),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      muscleGroup: $ExercisesTable.$convertermuscleGroup.fromJson(
        serializer.fromJson<String>(json['muscleGroup']),
      ),
      equipment: $ExercisesTable.$converterequipment.fromJson(
        serializer.fromJson<String>(json['equipment']),
      ),
      attribute: $ExercisesTable.$converterattribute.fromJson(
        serializer.fromJson<String>(json['attribute']),
      ),
      tracking: $ExercisesTable.$convertertracking.fromJson(
        serializer.fromJson<String>(json['tracking']),
      ),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'muscleGroup': serializer.toJson<String>(
        $ExercisesTable.$convertermuscleGroup.toJson(muscleGroup),
      ),
      'equipment': serializer.toJson<String>(
        $ExercisesTable.$converterequipment.toJson(equipment),
      ),
      'attribute': serializer.toJson<String>(
        $ExercisesTable.$converterattribute.toJson(attribute),
      ),
      'tracking': serializer.toJson<String>(
        $ExercisesTable.$convertertracking.toJson(tracking),
      ),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    MuscleGroup? muscleGroup,
    Equipment? equipment,
    Attribute? attribute,
    SetTracking? tracking,
    bool? isCustom,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    muscleGroup: muscleGroup ?? this.muscleGroup,
    equipment: equipment ?? this.equipment,
    attribute: attribute ?? this.attribute,
    tracking: tracking ?? this.tracking,
    isCustom: isCustom ?? this.isCustom,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      muscleGroup: data.muscleGroup.present
          ? data.muscleGroup.value
          : this.muscleGroup,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      attribute: data.attribute.present ? data.attribute.value : this.attribute,
      tracking: data.tracking.present ? data.tracking.value : this.tracking,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('attribute: $attribute, ')
          ..write('tracking: $tracking, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    muscleGroup,
    equipment,
    attribute,
    tracking,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.muscleGroup == this.muscleGroup &&
          other.equipment == this.equipment &&
          other.attribute == this.attribute &&
          other.tracking == this.tracking &&
          other.isCustom == this.isCustom);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> name;
  final Value<MuscleGroup> muscleGroup;
  final Value<Equipment> equipment;
  final Value<Attribute> attribute;
  final Value<SetTracking> tracking;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.equipment = const Value.absent(),
    this.attribute = const Value.absent(),
    this.tracking = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String name,
    required MuscleGroup muscleGroup,
    required Equipment equipment,
    required Attribute attribute,
    this.tracking = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       muscleGroup = Value(muscleGroup),
       equipment = Value(equipment),
       attribute = Value(attribute);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? muscleGroup,
    Expression<String>? equipment,
    Expression<String>? attribute,
    Expression<String>? tracking,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (equipment != null) 'equipment': equipment,
      if (attribute != null) 'attribute': attribute,
      if (tracking != null) 'tracking': tracking,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<MuscleGroup>? muscleGroup,
    Value<Equipment>? equipment,
    Value<Attribute>? attribute,
    Value<SetTracking>? tracking,
    Value<bool>? isCustom,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
      attribute: attribute ?? this.attribute,
      tracking: tracking ?? this.tracking,
      isCustom: isCustom ?? this.isCustom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(
        $ExercisesTable.$convertermuscleGroup.toSql(muscleGroup.value),
      );
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(
        $ExercisesTable.$converterequipment.toSql(equipment.value),
      );
    }
    if (attribute.present) {
      map['attribute'] = Variable<String>(
        $ExercisesTable.$converterattribute.toSql(attribute.value),
      );
    }
    if (tracking.present) {
      map['tracking'] = Variable<String>(
        $ExercisesTable.$convertertracking.toSql(tracking.value),
      );
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('equipment: $equipment, ')
          ..write('attribute: $attribute, ')
          ..write('tracking: $tracking, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineExercisesTable extends RoutineExercises
    with TableInfo<$RoutineExercisesTable, RoutineExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMinMeta = const VerificationMeta(
    'repsMin',
  );
  @override
  late final GeneratedColumn<int> repsMin = GeneratedColumn<int>(
    'reps_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMaxMeta = const VerificationMeta(
    'repsMax',
  );
  @override
  late final GeneratedColumn<int> repsMax = GeneratedColumn<int>(
    'reps_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toFailureMeta = const VerificationMeta(
    'toFailure',
  );
  @override
  late final GeneratedColumn<bool> toFailure = GeneratedColumn<bool>(
    'to_failure',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("to_failure" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineId,
    position,
    exerciseId,
    sets,
    repsMin,
    repsMax,
    durationSeconds,
    toFailure,
    restSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineExerciseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    } else if (isInserting) {
      context.missing(_setsMeta);
    }
    if (data.containsKey('reps_min')) {
      context.handle(
        _repsMinMeta,
        repsMin.isAcceptableOrUnknown(data['reps_min']!, _repsMinMeta),
      );
    }
    if (data.containsKey('reps_max')) {
      context.handle(
        _repsMaxMeta,
        repsMax.isAcceptableOrUnknown(data['reps_max']!, _repsMaxMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('to_failure')) {
      context.handle(
        _toFailureMeta,
        toFailure.isAcceptableOrUnknown(data['to_failure']!, _toFailureMeta),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineExerciseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      )!,
      repsMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_min'],
      ),
      repsMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_max'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      toFailure: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}to_failure'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
    );
  }

  @override
  $RoutineExercisesTable createAlias(String alias) {
    return $RoutineExercisesTable(attachedDatabase, alias);
  }
}

class RoutineExerciseRow extends DataClass
    implements Insertable<RoutineExerciseRow> {
  final int id;
  final String routineId;
  final int position;
  final String exerciseId;
  final int sets;
  final int? repsMin;
  final int? repsMax;
  final int? durationSeconds;
  final bool toFailure;
  final int restSeconds;
  const RoutineExerciseRow({
    required this.id,
    required this.routineId,
    required this.position,
    required this.exerciseId,
    required this.sets,
    this.repsMin,
    this.repsMax,
    this.durationSeconds,
    required this.toFailure,
    required this.restSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['position'] = Variable<int>(position);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sets'] = Variable<int>(sets);
    if (!nullToAbsent || repsMin != null) {
      map['reps_min'] = Variable<int>(repsMin);
    }
    if (!nullToAbsent || repsMax != null) {
      map['reps_max'] = Variable<int>(repsMax);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    map['to_failure'] = Variable<bool>(toFailure);
    map['rest_seconds'] = Variable<int>(restSeconds);
    return map;
  }

  RoutineExercisesCompanion toCompanion(bool nullToAbsent) {
    return RoutineExercisesCompanion(
      id: Value(id),
      routineId: Value(routineId),
      position: Value(position),
      exerciseId: Value(exerciseId),
      sets: Value(sets),
      repsMin: repsMin == null && nullToAbsent
          ? const Value.absent()
          : Value(repsMin),
      repsMax: repsMax == null && nullToAbsent
          ? const Value.absent()
          : Value(repsMax),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      toFailure: Value(toFailure),
      restSeconds: Value(restSeconds),
    );
  }

  factory RoutineExerciseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineExerciseRow(
      id: serializer.fromJson<int>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      position: serializer.fromJson<int>(json['position']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sets: serializer.fromJson<int>(json['sets']),
      repsMin: serializer.fromJson<int?>(json['repsMin']),
      repsMax: serializer.fromJson<int?>(json['repsMax']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      toFailure: serializer.fromJson<bool>(json['toFailure']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routineId': serializer.toJson<String>(routineId),
      'position': serializer.toJson<int>(position),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sets': serializer.toJson<int>(sets),
      'repsMin': serializer.toJson<int?>(repsMin),
      'repsMax': serializer.toJson<int?>(repsMax),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'toFailure': serializer.toJson<bool>(toFailure),
      'restSeconds': serializer.toJson<int>(restSeconds),
    };
  }

  RoutineExerciseRow copyWith({
    int? id,
    String? routineId,
    int? position,
    String? exerciseId,
    int? sets,
    Value<int?> repsMin = const Value.absent(),
    Value<int?> repsMax = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    bool? toFailure,
    int? restSeconds,
  }) => RoutineExerciseRow(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    position: position ?? this.position,
    exerciseId: exerciseId ?? this.exerciseId,
    sets: sets ?? this.sets,
    repsMin: repsMin.present ? repsMin.value : this.repsMin,
    repsMax: repsMax.present ? repsMax.value : this.repsMax,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    toFailure: toFailure ?? this.toFailure,
    restSeconds: restSeconds ?? this.restSeconds,
  );
  RoutineExerciseRow copyWithCompanion(RoutineExercisesCompanion data) {
    return RoutineExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      position: data.position.present ? data.position.value : this.position,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sets: data.sets.present ? data.sets.value : this.sets,
      repsMin: data.repsMin.present ? data.repsMin.value : this.repsMin,
      repsMax: data.repsMax.present ? data.repsMax.value : this.repsMax,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      toFailure: data.toFailure.present ? data.toFailure.value : this.toFailure,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineExerciseRow(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('position: $position, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('repsMin: $repsMin, ')
          ..write('repsMax: $repsMax, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('toFailure: $toFailure, ')
          ..write('restSeconds: $restSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    routineId,
    position,
    exerciseId,
    sets,
    repsMin,
    repsMax,
    durationSeconds,
    toFailure,
    restSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineExerciseRow &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.position == this.position &&
          other.exerciseId == this.exerciseId &&
          other.sets == this.sets &&
          other.repsMin == this.repsMin &&
          other.repsMax == this.repsMax &&
          other.durationSeconds == this.durationSeconds &&
          other.toFailure == this.toFailure &&
          other.restSeconds == this.restSeconds);
}

class RoutineExercisesCompanion extends UpdateCompanion<RoutineExerciseRow> {
  final Value<int> id;
  final Value<String> routineId;
  final Value<int> position;
  final Value<String> exerciseId;
  final Value<int> sets;
  final Value<int?> repsMin;
  final Value<int?> repsMax;
  final Value<int?> durationSeconds;
  final Value<bool> toFailure;
  final Value<int> restSeconds;
  const RoutineExercisesCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.position = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sets = const Value.absent(),
    this.repsMin = const Value.absent(),
    this.repsMax = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.toFailure = const Value.absent(),
    this.restSeconds = const Value.absent(),
  });
  RoutineExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String routineId,
    required int position,
    required String exerciseId,
    required int sets,
    this.repsMin = const Value.absent(),
    this.repsMax = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.toFailure = const Value.absent(),
    this.restSeconds = const Value.absent(),
  }) : routineId = Value(routineId),
       position = Value(position),
       exerciseId = Value(exerciseId),
       sets = Value(sets);
  static Insertable<RoutineExerciseRow> custom({
    Expression<int>? id,
    Expression<String>? routineId,
    Expression<int>? position,
    Expression<String>? exerciseId,
    Expression<int>? sets,
    Expression<int>? repsMin,
    Expression<int>? repsMax,
    Expression<int>? durationSeconds,
    Expression<bool>? toFailure,
    Expression<int>? restSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (position != null) 'position': position,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sets != null) 'sets': sets,
      if (repsMin != null) 'reps_min': repsMin,
      if (repsMax != null) 'reps_max': repsMax,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (toFailure != null) 'to_failure': toFailure,
      if (restSeconds != null) 'rest_seconds': restSeconds,
    });
  }

  RoutineExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? routineId,
    Value<int>? position,
    Value<String>? exerciseId,
    Value<int>? sets,
    Value<int?>? repsMin,
    Value<int?>? repsMax,
    Value<int?>? durationSeconds,
    Value<bool>? toFailure,
    Value<int>? restSeconds,
  }) {
    return RoutineExercisesCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      position: position ?? this.position,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      repsMin: repsMin ?? this.repsMin,
      repsMax: repsMax ?? this.repsMax,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      toFailure: toFailure ?? this.toFailure,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (repsMin.present) {
      map['reps_min'] = Variable<int>(repsMin.value);
    }
    if (repsMax.present) {
      map['reps_max'] = Variable<int>(repsMax.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (toFailure.present) {
      map['to_failure'] = Variable<bool>(toFailure.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineExercisesCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('position: $position, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('repsMin: $repsMin, ')
          ..write('repsMax: $repsMax, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('toFailure: $toFailure, ')
          ..write('restSeconds: $restSeconds')
          ..write(')'))
        .toString();
  }
}

class $HeroesTable extends Heroes with TableInfo<$HeroesTable, HeroRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeroesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HeroForm, String> form =
      GeneratedColumn<String>(
        'form',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HeroForm>($HeroesTable.$converterform);
  @override
  late final GeneratedColumnWithTypeConverter<HeroOrigin, String> origin =
      GeneratedColumn<String>(
        'origin',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HeroOrigin>($HeroesTable.$converterorigin);
  static const VerificationMeta _oathMeta = const VerificationMeta('oath');
  @override
  late final GeneratedColumn<String> oath = GeneratedColumn<String>(
    'oath',
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
  static const VerificationMeta _customOriginNameMeta = const VerificationMeta(
    'customOriginName',
  );
  @override
  late final GeneratedColumn<String> customOriginName = GeneratedColumn<String>(
    'custom_origin_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customOriginStoryMeta = const VerificationMeta(
    'customOriginStory',
  );
  @override
  late final GeneratedColumn<String> customOriginStory =
      GeneratedColumn<String>(
        'custom_origin_story',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _weeklyGoalMeta = const VerificationMeta(
    'weeklyGoal',
  );
  @override
  late final GeneratedColumn<int> weeklyGoal = GeneratedColumn<int>(
    'weekly_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _waterGoalCupsMeta = const VerificationMeta(
    'waterGoalCups',
  );
  @override
  late final GeneratedColumn<int> waterGoalCups = GeneratedColumn<int>(
    'water_goal_cups',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _equippedTitleIdMeta = const VerificationMeta(
    'equippedTitleId',
  );
  @override
  late final GeneratedColumn<String> equippedTitleId = GeneratedColumn<String>(
    'equipped_title_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _equippedCosmeticIdMeta =
      const VerificationMeta('equippedCosmeticId');
  @override
  late final GeneratedColumn<String> equippedCosmeticId =
      GeneratedColumn<String>(
        'equipped_cosmetic_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<CharacterClass?, String>
  selectedClass = GeneratedColumn<String>(
    'selected_class',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<CharacterClass?>($HeroesTable.$converterselectedClassn);
  static const VerificationMeta _appearanceMeta = const VerificationMeta(
    'appearance',
  );
  @override
  late final GeneratedColumn<String> appearance = GeneratedColumn<String>(
    'appearance',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    form,
    origin,
    oath,
    createdAt,
    customOriginName,
    customOriginStory,
    weeklyGoal,
    waterGoalCups,
    equippedTitleId,
    equippedCosmeticId,
    selectedClass,
    appearance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'heroes';
  @override
  VerificationContext validateIntegrity(
    Insertable<HeroRow> instance, {
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
    if (data.containsKey('oath')) {
      context.handle(
        _oathMeta,
        oath.isAcceptableOrUnknown(data['oath']!, _oathMeta),
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
    if (data.containsKey('custom_origin_name')) {
      context.handle(
        _customOriginNameMeta,
        customOriginName.isAcceptableOrUnknown(
          data['custom_origin_name']!,
          _customOriginNameMeta,
        ),
      );
    }
    if (data.containsKey('custom_origin_story')) {
      context.handle(
        _customOriginStoryMeta,
        customOriginStory.isAcceptableOrUnknown(
          data['custom_origin_story']!,
          _customOriginStoryMeta,
        ),
      );
    }
    if (data.containsKey('weekly_goal')) {
      context.handle(
        _weeklyGoalMeta,
        weeklyGoal.isAcceptableOrUnknown(data['weekly_goal']!, _weeklyGoalMeta),
      );
    }
    if (data.containsKey('water_goal_cups')) {
      context.handle(
        _waterGoalCupsMeta,
        waterGoalCups.isAcceptableOrUnknown(
          data['water_goal_cups']!,
          _waterGoalCupsMeta,
        ),
      );
    }
    if (data.containsKey('equipped_title_id')) {
      context.handle(
        _equippedTitleIdMeta,
        equippedTitleId.isAcceptableOrUnknown(
          data['equipped_title_id']!,
          _equippedTitleIdMeta,
        ),
      );
    }
    if (data.containsKey('equipped_cosmetic_id')) {
      context.handle(
        _equippedCosmeticIdMeta,
        equippedCosmeticId.isAcceptableOrUnknown(
          data['equipped_cosmetic_id']!,
          _equippedCosmeticIdMeta,
        ),
      );
    }
    if (data.containsKey('appearance')) {
      context.handle(
        _appearanceMeta,
        appearance.isAcceptableOrUnknown(data['appearance']!, _appearanceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeroRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeroRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      form: $HeroesTable.$converterform.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}form'],
        )!,
      ),
      origin: $HeroesTable.$converterorigin.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}origin'],
        )!,
      ),
      oath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}oath'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      customOriginName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_origin_name'],
      ),
      customOriginStory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_origin_story'],
      ),
      weeklyGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_goal'],
      )!,
      waterGoalCups: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_goal_cups'],
      )!,
      equippedTitleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipped_title_id'],
      ),
      equippedCosmeticId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipped_cosmetic_id'],
      ),
      selectedClass: $HeroesTable.$converterselectedClassn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}selected_class'],
        ),
      ),
      appearance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appearance'],
      ),
    );
  }

  @override
  $HeroesTable createAlias(String alias) {
    return $HeroesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HeroForm, String, String> $converterform =
      const EnumNameConverter<HeroForm>(HeroForm.values);
  static JsonTypeConverter2<HeroOrigin, String, String> $converterorigin =
      const EnumNameConverter<HeroOrigin>(HeroOrigin.values);
  static JsonTypeConverter2<CharacterClass, String, String>
  $converterselectedClass = const EnumNameConverter<CharacterClass>(
    CharacterClass.values,
  );
  static JsonTypeConverter2<CharacterClass?, String?, String?>
  $converterselectedClassn = JsonTypeConverter2.asNullable(
    $converterselectedClass,
  );
}

class HeroRow extends DataClass implements Insertable<HeroRow> {
  final int id;
  final String name;
  final HeroForm form;
  final HeroOrigin origin;
  final String? oath;
  final DateTime createdAt;

  /// Typed origin name/story when `origin` is custom (schema v4).
  final String? customOriginName;
  final String? customOriginStory;

  /// Training days per week the player aims for (schema v5).
  final int weeklyGoal;

  /// Daily hydration goal in 250 ml cups (schema v6).
  final int waterGoalCups;

  /// Currently equipped combat title id and cosmetic id (schema v7).
  final String? equippedTitleId;
  final String? equippedCosmeticId;

  /// Player-selected class when unlocked (`null` = emergent class, schema v8).
  final CharacterClass? selectedClass;

  /// Encoded modular Paper-Doll appearance (`HeroAppearance.encode()`, schema v9).
  final String? appearance;
  const HeroRow({
    required this.id,
    required this.name,
    required this.form,
    required this.origin,
    this.oath,
    required this.createdAt,
    this.customOriginName,
    this.customOriginStory,
    required this.weeklyGoal,
    required this.waterGoalCups,
    this.equippedTitleId,
    this.equippedCosmeticId,
    this.selectedClass,
    this.appearance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['form'] = Variable<String>($HeroesTable.$converterform.toSql(form));
    }
    {
      map['origin'] = Variable<String>(
        $HeroesTable.$converterorigin.toSql(origin),
      );
    }
    if (!nullToAbsent || oath != null) {
      map['oath'] = Variable<String>(oath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || customOriginName != null) {
      map['custom_origin_name'] = Variable<String>(customOriginName);
    }
    if (!nullToAbsent || customOriginStory != null) {
      map['custom_origin_story'] = Variable<String>(customOriginStory);
    }
    map['weekly_goal'] = Variable<int>(weeklyGoal);
    map['water_goal_cups'] = Variable<int>(waterGoalCups);
    if (!nullToAbsent || equippedTitleId != null) {
      map['equipped_title_id'] = Variable<String>(equippedTitleId);
    }
    if (!nullToAbsent || equippedCosmeticId != null) {
      map['equipped_cosmetic_id'] = Variable<String>(equippedCosmeticId);
    }
    if (!nullToAbsent || selectedClass != null) {
      map['selected_class'] = Variable<String>(
        $HeroesTable.$converterselectedClassn.toSql(selectedClass),
      );
    }
    if (!nullToAbsent || appearance != null) {
      map['appearance'] = Variable<String>(appearance);
    }
    return map;
  }

  HeroesCompanion toCompanion(bool nullToAbsent) {
    return HeroesCompanion(
      id: Value(id),
      name: Value(name),
      form: Value(form),
      origin: Value(origin),
      oath: oath == null && nullToAbsent ? const Value.absent() : Value(oath),
      createdAt: Value(createdAt),
      customOriginName: customOriginName == null && nullToAbsent
          ? const Value.absent()
          : Value(customOriginName),
      customOriginStory: customOriginStory == null && nullToAbsent
          ? const Value.absent()
          : Value(customOriginStory),
      weeklyGoal: Value(weeklyGoal),
      waterGoalCups: Value(waterGoalCups),
      equippedTitleId: equippedTitleId == null && nullToAbsent
          ? const Value.absent()
          : Value(equippedTitleId),
      equippedCosmeticId: equippedCosmeticId == null && nullToAbsent
          ? const Value.absent()
          : Value(equippedCosmeticId),
      selectedClass: selectedClass == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedClass),
      appearance: appearance == null && nullToAbsent
          ? const Value.absent()
          : Value(appearance),
    );
  }

  factory HeroRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeroRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      form: $HeroesTable.$converterform.fromJson(
        serializer.fromJson<String>(json['form']),
      ),
      origin: $HeroesTable.$converterorigin.fromJson(
        serializer.fromJson<String>(json['origin']),
      ),
      oath: serializer.fromJson<String?>(json['oath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      customOriginName: serializer.fromJson<String?>(json['customOriginName']),
      customOriginStory: serializer.fromJson<String?>(
        json['customOriginStory'],
      ),
      weeklyGoal: serializer.fromJson<int>(json['weeklyGoal']),
      waterGoalCups: serializer.fromJson<int>(json['waterGoalCups']),
      equippedTitleId: serializer.fromJson<String?>(json['equippedTitleId']),
      equippedCosmeticId: serializer.fromJson<String?>(
        json['equippedCosmeticId'],
      ),
      selectedClass: $HeroesTable.$converterselectedClassn.fromJson(
        serializer.fromJson<String?>(json['selectedClass']),
      ),
      appearance: serializer.fromJson<String?>(json['appearance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'form': serializer.toJson<String>(
        $HeroesTable.$converterform.toJson(form),
      ),
      'origin': serializer.toJson<String>(
        $HeroesTable.$converterorigin.toJson(origin),
      ),
      'oath': serializer.toJson<String?>(oath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'customOriginName': serializer.toJson<String?>(customOriginName),
      'customOriginStory': serializer.toJson<String?>(customOriginStory),
      'weeklyGoal': serializer.toJson<int>(weeklyGoal),
      'waterGoalCups': serializer.toJson<int>(waterGoalCups),
      'equippedTitleId': serializer.toJson<String?>(equippedTitleId),
      'equippedCosmeticId': serializer.toJson<String?>(equippedCosmeticId),
      'selectedClass': serializer.toJson<String?>(
        $HeroesTable.$converterselectedClassn.toJson(selectedClass),
      ),
      'appearance': serializer.toJson<String?>(appearance),
    };
  }

  HeroRow copyWith({
    int? id,
    String? name,
    HeroForm? form,
    HeroOrigin? origin,
    Value<String?> oath = const Value.absent(),
    DateTime? createdAt,
    Value<String?> customOriginName = const Value.absent(),
    Value<String?> customOriginStory = const Value.absent(),
    int? weeklyGoal,
    int? waterGoalCups,
    Value<String?> equippedTitleId = const Value.absent(),
    Value<String?> equippedCosmeticId = const Value.absent(),
    Value<CharacterClass?> selectedClass = const Value.absent(),
    Value<String?> appearance = const Value.absent(),
  }) => HeroRow(
    id: id ?? this.id,
    name: name ?? this.name,
    form: form ?? this.form,
    origin: origin ?? this.origin,
    oath: oath.present ? oath.value : this.oath,
    createdAt: createdAt ?? this.createdAt,
    customOriginName: customOriginName.present
        ? customOriginName.value
        : this.customOriginName,
    customOriginStory: customOriginStory.present
        ? customOriginStory.value
        : this.customOriginStory,
    weeklyGoal: weeklyGoal ?? this.weeklyGoal,
    waterGoalCups: waterGoalCups ?? this.waterGoalCups,
    equippedTitleId: equippedTitleId.present
        ? equippedTitleId.value
        : this.equippedTitleId,
    equippedCosmeticId: equippedCosmeticId.present
        ? equippedCosmeticId.value
        : this.equippedCosmeticId,
    selectedClass: selectedClass.present
        ? selectedClass.value
        : this.selectedClass,
    appearance: appearance.present ? appearance.value : this.appearance,
  );
  HeroRow copyWithCompanion(HeroesCompanion data) {
    return HeroRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      form: data.form.present ? data.form.value : this.form,
      origin: data.origin.present ? data.origin.value : this.origin,
      oath: data.oath.present ? data.oath.value : this.oath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      customOriginName: data.customOriginName.present
          ? data.customOriginName.value
          : this.customOriginName,
      customOriginStory: data.customOriginStory.present
          ? data.customOriginStory.value
          : this.customOriginStory,
      weeklyGoal: data.weeklyGoal.present
          ? data.weeklyGoal.value
          : this.weeklyGoal,
      waterGoalCups: data.waterGoalCups.present
          ? data.waterGoalCups.value
          : this.waterGoalCups,
      equippedTitleId: data.equippedTitleId.present
          ? data.equippedTitleId.value
          : this.equippedTitleId,
      equippedCosmeticId: data.equippedCosmeticId.present
          ? data.equippedCosmeticId.value
          : this.equippedCosmeticId,
      selectedClass: data.selectedClass.present
          ? data.selectedClass.value
          : this.selectedClass,
      appearance: data.appearance.present
          ? data.appearance.value
          : this.appearance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeroRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('form: $form, ')
          ..write('origin: $origin, ')
          ..write('oath: $oath, ')
          ..write('createdAt: $createdAt, ')
          ..write('customOriginName: $customOriginName, ')
          ..write('customOriginStory: $customOriginStory, ')
          ..write('weeklyGoal: $weeklyGoal, ')
          ..write('waterGoalCups: $waterGoalCups, ')
          ..write('equippedTitleId: $equippedTitleId, ')
          ..write('equippedCosmeticId: $equippedCosmeticId, ')
          ..write('selectedClass: $selectedClass, ')
          ..write('appearance: $appearance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    form,
    origin,
    oath,
    createdAt,
    customOriginName,
    customOriginStory,
    weeklyGoal,
    waterGoalCups,
    equippedTitleId,
    equippedCosmeticId,
    selectedClass,
    appearance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeroRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.form == this.form &&
          other.origin == this.origin &&
          other.oath == this.oath &&
          other.createdAt == this.createdAt &&
          other.customOriginName == this.customOriginName &&
          other.customOriginStory == this.customOriginStory &&
          other.weeklyGoal == this.weeklyGoal &&
          other.waterGoalCups == this.waterGoalCups &&
          other.equippedTitleId == this.equippedTitleId &&
          other.equippedCosmeticId == this.equippedCosmeticId &&
          other.selectedClass == this.selectedClass &&
          other.appearance == this.appearance);
}

class HeroesCompanion extends UpdateCompanion<HeroRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<HeroForm> form;
  final Value<HeroOrigin> origin;
  final Value<String?> oath;
  final Value<DateTime> createdAt;
  final Value<String?> customOriginName;
  final Value<String?> customOriginStory;
  final Value<int> weeklyGoal;
  final Value<int> waterGoalCups;
  final Value<String?> equippedTitleId;
  final Value<String?> equippedCosmeticId;
  final Value<CharacterClass?> selectedClass;
  final Value<String?> appearance;
  const HeroesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.form = const Value.absent(),
    this.origin = const Value.absent(),
    this.oath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.customOriginName = const Value.absent(),
    this.customOriginStory = const Value.absent(),
    this.weeklyGoal = const Value.absent(),
    this.waterGoalCups = const Value.absent(),
    this.equippedTitleId = const Value.absent(),
    this.equippedCosmeticId = const Value.absent(),
    this.selectedClass = const Value.absent(),
    this.appearance = const Value.absent(),
  });
  HeroesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required HeroForm form,
    required HeroOrigin origin,
    this.oath = const Value.absent(),
    required DateTime createdAt,
    this.customOriginName = const Value.absent(),
    this.customOriginStory = const Value.absent(),
    this.weeklyGoal = const Value.absent(),
    this.waterGoalCups = const Value.absent(),
    this.equippedTitleId = const Value.absent(),
    this.equippedCosmeticId = const Value.absent(),
    this.selectedClass = const Value.absent(),
    this.appearance = const Value.absent(),
  }) : name = Value(name),
       form = Value(form),
       origin = Value(origin),
       createdAt = Value(createdAt);
  static Insertable<HeroRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? form,
    Expression<String>? origin,
    Expression<String>? oath,
    Expression<DateTime>? createdAt,
    Expression<String>? customOriginName,
    Expression<String>? customOriginStory,
    Expression<int>? weeklyGoal,
    Expression<int>? waterGoalCups,
    Expression<String>? equippedTitleId,
    Expression<String>? equippedCosmeticId,
    Expression<String>? selectedClass,
    Expression<String>? appearance,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (form != null) 'form': form,
      if (origin != null) 'origin': origin,
      if (oath != null) 'oath': oath,
      if (createdAt != null) 'created_at': createdAt,
      if (customOriginName != null) 'custom_origin_name': customOriginName,
      if (customOriginStory != null) 'custom_origin_story': customOriginStory,
      if (weeklyGoal != null) 'weekly_goal': weeklyGoal,
      if (waterGoalCups != null) 'water_goal_cups': waterGoalCups,
      if (equippedTitleId != null) 'equipped_title_id': equippedTitleId,
      if (equippedCosmeticId != null)
        'equipped_cosmetic_id': equippedCosmeticId,
      if (selectedClass != null) 'selected_class': selectedClass,
      if (appearance != null) 'appearance': appearance,
    });
  }

  HeroesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<HeroForm>? form,
    Value<HeroOrigin>? origin,
    Value<String?>? oath,
    Value<DateTime>? createdAt,
    Value<String?>? customOriginName,
    Value<String?>? customOriginStory,
    Value<int>? weeklyGoal,
    Value<int>? waterGoalCups,
    Value<String?>? equippedTitleId,
    Value<String?>? equippedCosmeticId,
    Value<CharacterClass?>? selectedClass,
    Value<String?>? appearance,
  }) {
    return HeroesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      form: form ?? this.form,
      origin: origin ?? this.origin,
      oath: oath ?? this.oath,
      createdAt: createdAt ?? this.createdAt,
      customOriginName: customOriginName ?? this.customOriginName,
      customOriginStory: customOriginStory ?? this.customOriginStory,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      waterGoalCups: waterGoalCups ?? this.waterGoalCups,
      equippedTitleId: equippedTitleId ?? this.equippedTitleId,
      equippedCosmeticId: equippedCosmeticId ?? this.equippedCosmeticId,
      selectedClass: selectedClass ?? this.selectedClass,
      appearance: appearance ?? this.appearance,
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
    if (form.present) {
      map['form'] = Variable<String>(
        $HeroesTable.$converterform.toSql(form.value),
      );
    }
    if (origin.present) {
      map['origin'] = Variable<String>(
        $HeroesTable.$converterorigin.toSql(origin.value),
      );
    }
    if (oath.present) {
      map['oath'] = Variable<String>(oath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (customOriginName.present) {
      map['custom_origin_name'] = Variable<String>(customOriginName.value);
    }
    if (customOriginStory.present) {
      map['custom_origin_story'] = Variable<String>(customOriginStory.value);
    }
    if (weeklyGoal.present) {
      map['weekly_goal'] = Variable<int>(weeklyGoal.value);
    }
    if (waterGoalCups.present) {
      map['water_goal_cups'] = Variable<int>(waterGoalCups.value);
    }
    if (equippedTitleId.present) {
      map['equipped_title_id'] = Variable<String>(equippedTitleId.value);
    }
    if (equippedCosmeticId.present) {
      map['equipped_cosmetic_id'] = Variable<String>(equippedCosmeticId.value);
    }
    if (selectedClass.present) {
      map['selected_class'] = Variable<String>(
        $HeroesTable.$converterselectedClassn.toSql(selectedClass.value),
      );
    }
    if (appearance.present) {
      map['appearance'] = Variable<String>(appearance.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeroesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('form: $form, ')
          ..write('origin: $origin, ')
          ..write('oath: $oath, ')
          ..write('createdAt: $createdAt, ')
          ..write('customOriginName: $customOriginName, ')
          ..write('customOriginStory: $customOriginStory, ')
          ..write('weeklyGoal: $weeklyGoal, ')
          ..write('waterGoalCups: $waterGoalCups, ')
          ..write('equippedTitleId: $equippedTitleId, ')
          ..write('equippedCosmeticId: $equippedCosmeticId, ')
          ..write('selectedClass: $selectedClass, ')
          ..write('appearance: $appearance')
          ..write(')'))
        .toString();
  }
}

class $DailyHealthLogsTable extends DailyHealthLogs
    with TableInfo<$DailyHealthLogsTable, DailyHealthRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyHealthLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateStrMeta = const VerificationMeta(
    'dateStr',
  );
  @override
  late final GeneratedColumn<String> dateStr = GeneratedColumn<String>(
    'date_str',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterCupsMeta = const VerificationMeta(
    'waterCups',
  );
  @override
  late final GeneratedColumn<int> waterCups = GeneratedColumn<int>(
    'water_cups',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rewardedWaterCupsMeta = const VerificationMeta(
    'rewardedWaterCups',
  );
  @override
  late final GeneratedColumn<int> rewardedWaterCups = GeneratedColumn<int>(
    'rewarded_water_cups',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _waterGoalBonusClaimedMeta =
      const VerificationMeta('waterGoalBonusClaimed');
  @override
  late final GeneratedColumn<bool> waterGoalBonusClaimed =
      GeneratedColumn<bool>(
        'water_goal_bonus_claimed',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("water_goal_bonus_claimed" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  late final GeneratedColumnWithTypeConverter<DietAdherence?, String>
  dietAdherence =
      GeneratedColumn<String>(
        'diet_adherence',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DietAdherence?>(
        $DailyHealthLogsTable.$converterdietAdherencen,
      );
  static const VerificationMeta _lastSleepHoursMeta = const VerificationMeta(
    'lastSleepHours',
  );
  @override
  late final GeneratedColumn<double> lastSleepHours = GeneratedColumn<double>(
    'last_sleep_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    dateStr,
    waterCups,
    rewardedWaterCups,
    waterGoalBonusClaimed,
    dietAdherence,
    lastSleepHours,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_health_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyHealthRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date_str')) {
      context.handle(
        _dateStrMeta,
        dateStr.isAcceptableOrUnknown(data['date_str']!, _dateStrMeta),
      );
    } else if (isInserting) {
      context.missing(_dateStrMeta);
    }
    if (data.containsKey('water_cups')) {
      context.handle(
        _waterCupsMeta,
        waterCups.isAcceptableOrUnknown(data['water_cups']!, _waterCupsMeta),
      );
    }
    if (data.containsKey('rewarded_water_cups')) {
      context.handle(
        _rewardedWaterCupsMeta,
        rewardedWaterCups.isAcceptableOrUnknown(
          data['rewarded_water_cups']!,
          _rewardedWaterCupsMeta,
        ),
      );
    }
    if (data.containsKey('water_goal_bonus_claimed')) {
      context.handle(
        _waterGoalBonusClaimedMeta,
        waterGoalBonusClaimed.isAcceptableOrUnknown(
          data['water_goal_bonus_claimed']!,
          _waterGoalBonusClaimedMeta,
        ),
      );
    }
    if (data.containsKey('last_sleep_hours')) {
      context.handle(
        _lastSleepHoursMeta,
        lastSleepHours.isAcceptableOrUnknown(
          data['last_sleep_hours']!,
          _lastSleepHoursMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateStr};
  @override
  DailyHealthRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyHealthRow(
      dateStr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_str'],
      )!,
      waterCups: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}water_cups'],
      )!,
      rewardedWaterCups: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rewarded_water_cups'],
      )!,
      waterGoalBonusClaimed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}water_goal_bonus_claimed'],
      )!,
      dietAdherence: $DailyHealthLogsTable.$converterdietAdherencen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}diet_adherence'],
        ),
      ),
      lastSleepHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_sleep_hours'],
      ),
    );
  }

  @override
  $DailyHealthLogsTable createAlias(String alias) {
    return $DailyHealthLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DietAdherence, String, String>
  $converterdietAdherence = const EnumNameConverter<DietAdherence>(
    DietAdherence.values,
  );
  static JsonTypeConverter2<DietAdherence?, String?, String?>
  $converterdietAdherencen = JsonTypeConverter2.asNullable(
    $converterdietAdherence,
  );
}

class DailyHealthRow extends DataClass implements Insertable<DailyHealthRow> {
  final String dateStr;
  final int waterCups;
  final int rewardedWaterCups;
  final bool waterGoalBonusClaimed;
  final DietAdherence? dietAdherence;
  final double? lastSleepHours;
  const DailyHealthRow({
    required this.dateStr,
    required this.waterCups,
    required this.rewardedWaterCups,
    required this.waterGoalBonusClaimed,
    this.dietAdherence,
    this.lastSleepHours,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_str'] = Variable<String>(dateStr);
    map['water_cups'] = Variable<int>(waterCups);
    map['rewarded_water_cups'] = Variable<int>(rewardedWaterCups);
    map['water_goal_bonus_claimed'] = Variable<bool>(waterGoalBonusClaimed);
    if (!nullToAbsent || dietAdherence != null) {
      map['diet_adherence'] = Variable<String>(
        $DailyHealthLogsTable.$converterdietAdherencen.toSql(dietAdherence),
      );
    }
    if (!nullToAbsent || lastSleepHours != null) {
      map['last_sleep_hours'] = Variable<double>(lastSleepHours);
    }
    return map;
  }

  DailyHealthLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyHealthLogsCompanion(
      dateStr: Value(dateStr),
      waterCups: Value(waterCups),
      rewardedWaterCups: Value(rewardedWaterCups),
      waterGoalBonusClaimed: Value(waterGoalBonusClaimed),
      dietAdherence: dietAdherence == null && nullToAbsent
          ? const Value.absent()
          : Value(dietAdherence),
      lastSleepHours: lastSleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSleepHours),
    );
  }

  factory DailyHealthRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyHealthRow(
      dateStr: serializer.fromJson<String>(json['dateStr']),
      waterCups: serializer.fromJson<int>(json['waterCups']),
      rewardedWaterCups: serializer.fromJson<int>(json['rewardedWaterCups']),
      waterGoalBonusClaimed: serializer.fromJson<bool>(
        json['waterGoalBonusClaimed'],
      ),
      dietAdherence: $DailyHealthLogsTable.$converterdietAdherencen.fromJson(
        serializer.fromJson<String?>(json['dietAdherence']),
      ),
      lastSleepHours: serializer.fromJson<double?>(json['lastSleepHours']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateStr': serializer.toJson<String>(dateStr),
      'waterCups': serializer.toJson<int>(waterCups),
      'rewardedWaterCups': serializer.toJson<int>(rewardedWaterCups),
      'waterGoalBonusClaimed': serializer.toJson<bool>(waterGoalBonusClaimed),
      'dietAdherence': serializer.toJson<String?>(
        $DailyHealthLogsTable.$converterdietAdherencen.toJson(dietAdherence),
      ),
      'lastSleepHours': serializer.toJson<double?>(lastSleepHours),
    };
  }

  DailyHealthRow copyWith({
    String? dateStr,
    int? waterCups,
    int? rewardedWaterCups,
    bool? waterGoalBonusClaimed,
    Value<DietAdherence?> dietAdherence = const Value.absent(),
    Value<double?> lastSleepHours = const Value.absent(),
  }) => DailyHealthRow(
    dateStr: dateStr ?? this.dateStr,
    waterCups: waterCups ?? this.waterCups,
    rewardedWaterCups: rewardedWaterCups ?? this.rewardedWaterCups,
    waterGoalBonusClaimed: waterGoalBonusClaimed ?? this.waterGoalBonusClaimed,
    dietAdherence: dietAdherence.present
        ? dietAdherence.value
        : this.dietAdherence,
    lastSleepHours: lastSleepHours.present
        ? lastSleepHours.value
        : this.lastSleepHours,
  );
  DailyHealthRow copyWithCompanion(DailyHealthLogsCompanion data) {
    return DailyHealthRow(
      dateStr: data.dateStr.present ? data.dateStr.value : this.dateStr,
      waterCups: data.waterCups.present ? data.waterCups.value : this.waterCups,
      rewardedWaterCups: data.rewardedWaterCups.present
          ? data.rewardedWaterCups.value
          : this.rewardedWaterCups,
      waterGoalBonusClaimed: data.waterGoalBonusClaimed.present
          ? data.waterGoalBonusClaimed.value
          : this.waterGoalBonusClaimed,
      dietAdherence: data.dietAdherence.present
          ? data.dietAdherence.value
          : this.dietAdherence,
      lastSleepHours: data.lastSleepHours.present
          ? data.lastSleepHours.value
          : this.lastSleepHours,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyHealthRow(')
          ..write('dateStr: $dateStr, ')
          ..write('waterCups: $waterCups, ')
          ..write('rewardedWaterCups: $rewardedWaterCups, ')
          ..write('waterGoalBonusClaimed: $waterGoalBonusClaimed, ')
          ..write('dietAdherence: $dietAdherence, ')
          ..write('lastSleepHours: $lastSleepHours')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    dateStr,
    waterCups,
    rewardedWaterCups,
    waterGoalBonusClaimed,
    dietAdherence,
    lastSleepHours,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyHealthRow &&
          other.dateStr == this.dateStr &&
          other.waterCups == this.waterCups &&
          other.rewardedWaterCups == this.rewardedWaterCups &&
          other.waterGoalBonusClaimed == this.waterGoalBonusClaimed &&
          other.dietAdherence == this.dietAdherence &&
          other.lastSleepHours == this.lastSleepHours);
}

class DailyHealthLogsCompanion extends UpdateCompanion<DailyHealthRow> {
  final Value<String> dateStr;
  final Value<int> waterCups;
  final Value<int> rewardedWaterCups;
  final Value<bool> waterGoalBonusClaimed;
  final Value<DietAdherence?> dietAdherence;
  final Value<double?> lastSleepHours;
  final Value<int> rowid;
  const DailyHealthLogsCompanion({
    this.dateStr = const Value.absent(),
    this.waterCups = const Value.absent(),
    this.rewardedWaterCups = const Value.absent(),
    this.waterGoalBonusClaimed = const Value.absent(),
    this.dietAdherence = const Value.absent(),
    this.lastSleepHours = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyHealthLogsCompanion.insert({
    required String dateStr,
    this.waterCups = const Value.absent(),
    this.rewardedWaterCups = const Value.absent(),
    this.waterGoalBonusClaimed = const Value.absent(),
    this.dietAdherence = const Value.absent(),
    this.lastSleepHours = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dateStr = Value(dateStr);
  static Insertable<DailyHealthRow> custom({
    Expression<String>? dateStr,
    Expression<int>? waterCups,
    Expression<int>? rewardedWaterCups,
    Expression<bool>? waterGoalBonusClaimed,
    Expression<String>? dietAdherence,
    Expression<double>? lastSleepHours,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dateStr != null) 'date_str': dateStr,
      if (waterCups != null) 'water_cups': waterCups,
      if (rewardedWaterCups != null) 'rewarded_water_cups': rewardedWaterCups,
      if (waterGoalBonusClaimed != null)
        'water_goal_bonus_claimed': waterGoalBonusClaimed,
      if (dietAdherence != null) 'diet_adherence': dietAdherence,
      if (lastSleepHours != null) 'last_sleep_hours': lastSleepHours,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyHealthLogsCompanion copyWith({
    Value<String>? dateStr,
    Value<int>? waterCups,
    Value<int>? rewardedWaterCups,
    Value<bool>? waterGoalBonusClaimed,
    Value<DietAdherence?>? dietAdherence,
    Value<double?>? lastSleepHours,
    Value<int>? rowid,
  }) {
    return DailyHealthLogsCompanion(
      dateStr: dateStr ?? this.dateStr,
      waterCups: waterCups ?? this.waterCups,
      rewardedWaterCups: rewardedWaterCups ?? this.rewardedWaterCups,
      waterGoalBonusClaimed:
          waterGoalBonusClaimed ?? this.waterGoalBonusClaimed,
      dietAdherence: dietAdherence ?? this.dietAdherence,
      lastSleepHours: lastSleepHours ?? this.lastSleepHours,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateStr.present) {
      map['date_str'] = Variable<String>(dateStr.value);
    }
    if (waterCups.present) {
      map['water_cups'] = Variable<int>(waterCups.value);
    }
    if (rewardedWaterCups.present) {
      map['rewarded_water_cups'] = Variable<int>(rewardedWaterCups.value);
    }
    if (waterGoalBonusClaimed.present) {
      map['water_goal_bonus_claimed'] = Variable<bool>(
        waterGoalBonusClaimed.value,
      );
    }
    if (dietAdherence.present) {
      map['diet_adherence'] = Variable<String>(
        $DailyHealthLogsTable.$converterdietAdherencen.toSql(
          dietAdherence.value,
        ),
      );
    }
    if (lastSleepHours.present) {
      map['last_sleep_hours'] = Variable<double>(lastSleepHours.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyHealthLogsCompanion(')
          ..write('dateStr: $dateStr, ')
          ..write('waterCups: $waterCups, ')
          ..write('rewardedWaterCups: $rewardedWaterCups, ')
          ..write('waterGoalBonusClaimed: $waterGoalBonusClaimed, ')
          ..write('dietAdherence: $dietAdherence, ')
          ..write('lastSleepHours: $lastSleepHours, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArenaProgressTable extends ArenaProgress
    with TableInfo<$ArenaProgressTable, ArenaProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArenaProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opponentIdMeta = const VerificationMeta(
    'opponentId',
  );
  @override
  late final GeneratedColumn<String> opponentId = GeneratedColumn<String>(
    'opponent_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _victoriesMeta = const VerificationMeta(
    'victories',
  );
  @override
  late final GeneratedColumn<int> victories = GeneratedColumn<int>(
    'victories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastDefeatedAtMeta = const VerificationMeta(
    'lastDefeatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastDefeatedAt =
      GeneratedColumn<DateTime>(
        'last_defeated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [opponentId, victories, lastDefeatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'arena_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArenaProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('opponent_id')) {
      context.handle(
        _opponentIdMeta,
        opponentId.isAcceptableOrUnknown(data['opponent_id']!, _opponentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opponentIdMeta);
    }
    if (data.containsKey('victories')) {
      context.handle(
        _victoriesMeta,
        victories.isAcceptableOrUnknown(data['victories']!, _victoriesMeta),
      );
    }
    if (data.containsKey('last_defeated_at')) {
      context.handle(
        _lastDefeatedAtMeta,
        lastDefeatedAt.isAcceptableOrUnknown(
          data['last_defeated_at']!,
          _lastDefeatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastDefeatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {opponentId};
  @override
  ArenaProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArenaProgressRow(
      opponentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opponent_id'],
      )!,
      victories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}victories'],
      )!,
      lastDefeatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_defeated_at'],
      )!,
    );
  }

  @override
  $ArenaProgressTable createAlias(String alias) {
    return $ArenaProgressTable(attachedDatabase, alias);
  }
}

class ArenaProgressRow extends DataClass
    implements Insertable<ArenaProgressRow> {
  final String opponentId;
  final int victories;
  final DateTime lastDefeatedAt;
  const ArenaProgressRow({
    required this.opponentId,
    required this.victories,
    required this.lastDefeatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['opponent_id'] = Variable<String>(opponentId);
    map['victories'] = Variable<int>(victories);
    map['last_defeated_at'] = Variable<DateTime>(lastDefeatedAt);
    return map;
  }

  ArenaProgressCompanion toCompanion(bool nullToAbsent) {
    return ArenaProgressCompanion(
      opponentId: Value(opponentId),
      victories: Value(victories),
      lastDefeatedAt: Value(lastDefeatedAt),
    );
  }

  factory ArenaProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArenaProgressRow(
      opponentId: serializer.fromJson<String>(json['opponentId']),
      victories: serializer.fromJson<int>(json['victories']),
      lastDefeatedAt: serializer.fromJson<DateTime>(json['lastDefeatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opponentId': serializer.toJson<String>(opponentId),
      'victories': serializer.toJson<int>(victories),
      'lastDefeatedAt': serializer.toJson<DateTime>(lastDefeatedAt),
    };
  }

  ArenaProgressRow copyWith({
    String? opponentId,
    int? victories,
    DateTime? lastDefeatedAt,
  }) => ArenaProgressRow(
    opponentId: opponentId ?? this.opponentId,
    victories: victories ?? this.victories,
    lastDefeatedAt: lastDefeatedAt ?? this.lastDefeatedAt,
  );
  ArenaProgressRow copyWithCompanion(ArenaProgressCompanion data) {
    return ArenaProgressRow(
      opponentId: data.opponentId.present
          ? data.opponentId.value
          : this.opponentId,
      victories: data.victories.present ? data.victories.value : this.victories,
      lastDefeatedAt: data.lastDefeatedAt.present
          ? data.lastDefeatedAt.value
          : this.lastDefeatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArenaProgressRow(')
          ..write('opponentId: $opponentId, ')
          ..write('victories: $victories, ')
          ..write('lastDefeatedAt: $lastDefeatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(opponentId, victories, lastDefeatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArenaProgressRow &&
          other.opponentId == this.opponentId &&
          other.victories == this.victories &&
          other.lastDefeatedAt == this.lastDefeatedAt);
}

class ArenaProgressCompanion extends UpdateCompanion<ArenaProgressRow> {
  final Value<String> opponentId;
  final Value<int> victories;
  final Value<DateTime> lastDefeatedAt;
  final Value<int> rowid;
  const ArenaProgressCompanion({
    this.opponentId = const Value.absent(),
    this.victories = const Value.absent(),
    this.lastDefeatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArenaProgressCompanion.insert({
    required String opponentId,
    this.victories = const Value.absent(),
    required DateTime lastDefeatedAt,
    this.rowid = const Value.absent(),
  }) : opponentId = Value(opponentId),
       lastDefeatedAt = Value(lastDefeatedAt);
  static Insertable<ArenaProgressRow> custom({
    Expression<String>? opponentId,
    Expression<int>? victories,
    Expression<DateTime>? lastDefeatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opponentId != null) 'opponent_id': opponentId,
      if (victories != null) 'victories': victories,
      if (lastDefeatedAt != null) 'last_defeated_at': lastDefeatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArenaProgressCompanion copyWith({
    Value<String>? opponentId,
    Value<int>? victories,
    Value<DateTime>? lastDefeatedAt,
    Value<int>? rowid,
  }) {
    return ArenaProgressCompanion(
      opponentId: opponentId ?? this.opponentId,
      victories: victories ?? this.victories,
      lastDefeatedAt: lastDefeatedAt ?? this.lastDefeatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opponentId.present) {
      map['opponent_id'] = Variable<String>(opponentId.value);
    }
    if (victories.present) {
      map['victories'] = Variable<int>(victories.value);
    }
    if (lastDefeatedAt.present) {
      map['last_defeated_at'] = Variable<DateTime>(lastDefeatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArenaProgressCompanion(')
          ..write('opponentId: $opponentId, ')
          ..write('victories: $victories, ')
          ..write('lastDefeatedAt: $lastDefeatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyArenaLogsTable extends DailyArenaLogs
    with TableInfo<$DailyArenaLogsTable, DailyArenaLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyArenaLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateStrMeta = const VerificationMeta(
    'dateStr',
  );
  @override
  late final GeneratedColumn<String> dateStr = GeneratedColumn<String>(
    'date_str',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entriesUsedMeta = const VerificationMeta(
    'entriesUsed',
  );
  @override
  late final GeneratedColumn<int> entriesUsed = GeneratedColumn<int>(
    'entries_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [dateStr, entriesUsed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_arena_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyArenaLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date_str')) {
      context.handle(
        _dateStrMeta,
        dateStr.isAcceptableOrUnknown(data['date_str']!, _dateStrMeta),
      );
    } else if (isInserting) {
      context.missing(_dateStrMeta);
    }
    if (data.containsKey('entries_used')) {
      context.handle(
        _entriesUsedMeta,
        entriesUsed.isAcceptableOrUnknown(
          data['entries_used']!,
          _entriesUsedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateStr};
  @override
  DailyArenaLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyArenaLogRow(
      dateStr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_str'],
      )!,
      entriesUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entries_used'],
      )!,
    );
  }

  @override
  $DailyArenaLogsTable createAlias(String alias) {
    return $DailyArenaLogsTable(attachedDatabase, alias);
  }
}

class DailyArenaLogRow extends DataClass
    implements Insertable<DailyArenaLogRow> {
  final String dateStr;
  final int entriesUsed;
  const DailyArenaLogRow({required this.dateStr, required this.entriesUsed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_str'] = Variable<String>(dateStr);
    map['entries_used'] = Variable<int>(entriesUsed);
    return map;
  }

  DailyArenaLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyArenaLogsCompanion(
      dateStr: Value(dateStr),
      entriesUsed: Value(entriesUsed),
    );
  }

  factory DailyArenaLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyArenaLogRow(
      dateStr: serializer.fromJson<String>(json['dateStr']),
      entriesUsed: serializer.fromJson<int>(json['entriesUsed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateStr': serializer.toJson<String>(dateStr),
      'entriesUsed': serializer.toJson<int>(entriesUsed),
    };
  }

  DailyArenaLogRow copyWith({String? dateStr, int? entriesUsed}) =>
      DailyArenaLogRow(
        dateStr: dateStr ?? this.dateStr,
        entriesUsed: entriesUsed ?? this.entriesUsed,
      );
  DailyArenaLogRow copyWithCompanion(DailyArenaLogsCompanion data) {
    return DailyArenaLogRow(
      dateStr: data.dateStr.present ? data.dateStr.value : this.dateStr,
      entriesUsed: data.entriesUsed.present
          ? data.entriesUsed.value
          : this.entriesUsed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyArenaLogRow(')
          ..write('dateStr: $dateStr, ')
          ..write('entriesUsed: $entriesUsed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dateStr, entriesUsed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyArenaLogRow &&
          other.dateStr == this.dateStr &&
          other.entriesUsed == this.entriesUsed);
}

class DailyArenaLogsCompanion extends UpdateCompanion<DailyArenaLogRow> {
  final Value<String> dateStr;
  final Value<int> entriesUsed;
  final Value<int> rowid;
  const DailyArenaLogsCompanion({
    this.dateStr = const Value.absent(),
    this.entriesUsed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyArenaLogsCompanion.insert({
    required String dateStr,
    this.entriesUsed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dateStr = Value(dateStr);
  static Insertable<DailyArenaLogRow> custom({
    Expression<String>? dateStr,
    Expression<int>? entriesUsed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dateStr != null) 'date_str': dateStr,
      if (entriesUsed != null) 'entries_used': entriesUsed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyArenaLogsCompanion copyWith({
    Value<String>? dateStr,
    Value<int>? entriesUsed,
    Value<int>? rowid,
  }) {
    return DailyArenaLogsCompanion(
      dateStr: dateStr ?? this.dateStr,
      entriesUsed: entriesUsed ?? this.entriesUsed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateStr.present) {
      map['date_str'] = Variable<String>(dateStr.value);
    }
    if (entriesUsed.present) {
      map['entries_used'] = Variable<int>(entriesUsed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyArenaLogsCompanion(')
          ..write('dateStr: $dateStr, ')
          ..write('entriesUsed: $entriesUsed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    startedAt,
    completedAt,
    notes,
    routineId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final String title;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? notes;

  /// Routine this session was started from (template or custom id), if any.
  final String? routineId;
  const WorkoutSession({
    required this.id,
    required this.title,
    required this.startedAt,
    this.completedAt,
    this.notes,
    this.routineId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || routineId != null) {
      map['routine_id'] = Variable<String>(routineId);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      title: Value(title),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      routineId: routineId == null && nullToAbsent
          ? const Value.absent()
          : Value(routineId),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      routineId: serializer.fromJson<String?>(json['routineId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'notes': serializer.toJson<String?>(notes),
      'routineId': serializer.toJson<String?>(routineId),
    };
  }

  WorkoutSession copyWith({
    String? id,
    String? title,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> routineId = const Value.absent(),
  }) => WorkoutSession(
    id: id ?? this.id,
    title: title ?? this.title,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    notes: notes.present ? notes.value : this.notes,
    routineId: routineId.present ? routineId.value : this.routineId,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('routineId: $routineId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, startedAt, completedAt, notes, routineId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.title == this.title &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes &&
          other.routineId == this.routineId);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String?> notes;
  final Value<String?> routineId;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.routineId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required String title,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.routineId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       startedAt = Value(startedAt);
  static Insertable<WorkoutSession> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? notes,
    Expression<String>? routineId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (routineId != null) 'routine_id': routineId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String?>? notes,
    Value<String?>? routineId,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      routineId: routineId ?? this.routineId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('routineId: $routineId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _setOrderMeta = const VerificationMeta(
    'setOrder',
  );
  @override
  late final GeneratedColumn<int> setOrder = GeneratedColumn<int>(
    'set_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
    'rpe',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(8.0),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPersonalRecordMeta = const VerificationMeta(
    'isPersonalRecord',
  );
  @override
  late final GeneratedColumn<bool> isPersonalRecord = GeneratedColumn<bool>(
    'is_personal_record',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_personal_record" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    exerciseId,
    setOrder,
    weightKg,
    reps,
    durationSeconds,
    rpe,
    isCompleted,
    isPersonalRecord,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_order')) {
      context.handle(
        _setOrderMeta,
        setOrder.isAcceptableOrUnknown(data['set_order']!, _setOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_setOrderMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('rpe')) {
      context.handle(
        _rpeMeta,
        rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('is_personal_record')) {
      context.handle(
        _isPersonalRecordMeta,
        isPersonalRecord.isAcceptableOrUnknown(
          data['is_personal_record']!,
          _isPersonalRecordMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      setOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_order'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      rpe: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rpe'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      isPersonalRecord: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_personal_record'],
      )!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final String id;
  final String sessionId;
  final String exerciseId;
  final int setOrder;
  final double weightKg;
  final int reps;

  /// Duration of timed sets (planks, cardio). 0 for weight/reps sets.
  final int durationSeconds;
  final double rpe;
  final bool isCompleted;
  final bool isPersonalRecord;
  const WorkoutSet({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.setOrder,
    required this.weightKg,
    required this.reps,
    required this.durationSeconds,
    required this.rpe,
    required this.isCompleted,
    required this.isPersonalRecord,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['set_order'] = Variable<int>(setOrder);
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['rpe'] = Variable<double>(rpe);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_personal_record'] = Variable<bool>(isPersonalRecord);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      exerciseId: Value(exerciseId),
      setOrder: Value(setOrder),
      weightKg: Value(weightKg),
      reps: Value(reps),
      durationSeconds: Value(durationSeconds),
      rpe: Value(rpe),
      isCompleted: Value(isCompleted),
      isPersonalRecord: Value(isPersonalRecord),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      setOrder: serializer.fromJson<int>(json['setOrder']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      rpe: serializer.fromJson<double>(json['rpe']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isPersonalRecord: serializer.fromJson<bool>(json['isPersonalRecord']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'setOrder': serializer.toJson<int>(setOrder),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'rpe': serializer.toJson<double>(rpe),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isPersonalRecord': serializer.toJson<bool>(isPersonalRecord),
    };
  }

  WorkoutSet copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    int? setOrder,
    double? weightKg,
    int? reps,
    int? durationSeconds,
    double? rpe,
    bool? isCompleted,
    bool? isPersonalRecord,
  }) => WorkoutSet(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    exerciseId: exerciseId ?? this.exerciseId,
    setOrder: setOrder ?? this.setOrder,
    weightKg: weightKg ?? this.weightKg,
    reps: reps ?? this.reps,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    rpe: rpe ?? this.rpe,
    isCompleted: isCompleted ?? this.isCompleted,
    isPersonalRecord: isPersonalRecord ?? this.isPersonalRecord,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      setOrder: data.setOrder.present ? data.setOrder.value : this.setOrder,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      isPersonalRecord: data.isPersonalRecord.present
          ? data.isPersonalRecord.value
          : this.isPersonalRecord,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setOrder: $setOrder, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rpe: $rpe, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isPersonalRecord: $isPersonalRecord')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    exerciseId,
    setOrder,
    weightKg,
    reps,
    durationSeconds,
    rpe,
    isCompleted,
    isPersonalRecord,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.exerciseId == this.exerciseId &&
          other.setOrder == this.setOrder &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.durationSeconds == this.durationSeconds &&
          other.rpe == this.rpe &&
          other.isCompleted == this.isCompleted &&
          other.isPersonalRecord == this.isPersonalRecord);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> exerciseId;
  final Value<int> setOrder;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<int> durationSeconds;
  final Value<double> rpe;
  final Value<bool> isCompleted;
  final Value<bool> isPersonalRecord;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setOrder = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rpe = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isPersonalRecord = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    required String id,
    required String sessionId,
    required String exerciseId,
    required int setOrder,
    required double weightKg,
    required int reps,
    this.durationSeconds = const Value.absent(),
    this.rpe = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isPersonalRecord = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       exerciseId = Value(exerciseId),
       setOrder = Value(setOrder),
       weightKg = Value(weightKg),
       reps = Value(reps);
  static Insertable<WorkoutSet> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? exerciseId,
    Expression<int>? setOrder,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<int>? durationSeconds,
    Expression<double>? rpe,
    Expression<bool>? isCompleted,
    Expression<bool>? isPersonalRecord,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setOrder != null) 'set_order': setOrder,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (rpe != null) 'rpe': rpe,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isPersonalRecord != null) 'is_personal_record': isPersonalRecord,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? exerciseId,
    Value<int>? setOrder,
    Value<double>? weightKg,
    Value<int>? reps,
    Value<int>? durationSeconds,
    Value<double>? rpe,
    Value<bool>? isCompleted,
    Value<bool>? isPersonalRecord,
    Value<int>? rowid,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setOrder: setOrder ?? this.setOrder,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      rpe: rpe ?? this.rpe,
      isCompleted: isCompleted ?? this.isCompleted,
      isPersonalRecord: isPersonalRecord ?? this.isPersonalRecord,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (setOrder.present) {
      map['set_order'] = Variable<int>(setOrder.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isPersonalRecord.present) {
      map['is_personal_record'] = Variable<bool>(isPersonalRecord.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setOrder: $setOrder, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rpe: $rpe, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isPersonalRecord: $isPersonalRecord, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonalRecordsTable extends PersonalRecords
    with TableInfo<$PersonalRecordsTable, PersonalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _maxWeightKgMeta = const VerificationMeta(
    'maxWeightKg',
  );
  @override
  late final GeneratedColumn<double> maxWeightKg = GeneratedColumn<double>(
    'max_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedOneRepMaxMeta =
      const VerificationMeta('estimatedOneRepMax');
  @override
  late final GeneratedColumn<double> estimatedOneRepMax =
      GeneratedColumn<double>(
        'estimated_one_rep_max',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _repsAtMaxWeightMeta = const VerificationMeta(
    'repsAtMaxWeight',
  );
  @override
  late final GeneratedColumn<int> repsAtMaxWeight = GeneratedColumn<int>(
    'reps_at_max_weight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    exerciseId,
    maxWeightKg,
    estimatedOneRepMax,
    repsAtMaxWeight,
    achievedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('max_weight_kg')) {
      context.handle(
        _maxWeightKgMeta,
        maxWeightKg.isAcceptableOrUnknown(
          data['max_weight_kg']!,
          _maxWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxWeightKgMeta);
    }
    if (data.containsKey('estimated_one_rep_max')) {
      context.handle(
        _estimatedOneRepMaxMeta,
        estimatedOneRepMax.isAcceptableOrUnknown(
          data['estimated_one_rep_max']!,
          _estimatedOneRepMaxMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedOneRepMaxMeta);
    }
    if (data.containsKey('reps_at_max_weight')) {
      context.handle(
        _repsAtMaxWeightMeta,
        repsAtMaxWeight.isAcceptableOrUnknown(
          data['reps_at_max_weight']!,
          _repsAtMaxWeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repsAtMaxWeightMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exerciseId};
  @override
  PersonalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalRecord(
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      maxWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_weight_kg'],
      )!,
      estimatedOneRepMax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}estimated_one_rep_max'],
      )!,
      repsAtMaxWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps_at_max_weight'],
      )!,
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
    );
  }

  @override
  $PersonalRecordsTable createAlias(String alias) {
    return $PersonalRecordsTable(attachedDatabase, alias);
  }
}

class PersonalRecord extends DataClass implements Insertable<PersonalRecord> {
  final String exerciseId;
  final double maxWeightKg;
  final double estimatedOneRepMax;
  final int repsAtMaxWeight;
  final DateTime achievedAt;
  const PersonalRecord({
    required this.exerciseId,
    required this.maxWeightKg,
    required this.estimatedOneRepMax,
    required this.repsAtMaxWeight,
    required this.achievedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['exercise_id'] = Variable<String>(exerciseId);
    map['max_weight_kg'] = Variable<double>(maxWeightKg);
    map['estimated_one_rep_max'] = Variable<double>(estimatedOneRepMax);
    map['reps_at_max_weight'] = Variable<int>(repsAtMaxWeight);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    return map;
  }

  PersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return PersonalRecordsCompanion(
      exerciseId: Value(exerciseId),
      maxWeightKg: Value(maxWeightKg),
      estimatedOneRepMax: Value(estimatedOneRepMax),
      repsAtMaxWeight: Value(repsAtMaxWeight),
      achievedAt: Value(achievedAt),
    );
  }

  factory PersonalRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalRecord(
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      maxWeightKg: serializer.fromJson<double>(json['maxWeightKg']),
      estimatedOneRepMax: serializer.fromJson<double>(
        json['estimatedOneRepMax'],
      ),
      repsAtMaxWeight: serializer.fromJson<int>(json['repsAtMaxWeight']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'exerciseId': serializer.toJson<String>(exerciseId),
      'maxWeightKg': serializer.toJson<double>(maxWeightKg),
      'estimatedOneRepMax': serializer.toJson<double>(estimatedOneRepMax),
      'repsAtMaxWeight': serializer.toJson<int>(repsAtMaxWeight),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
    };
  }

  PersonalRecord copyWith({
    String? exerciseId,
    double? maxWeightKg,
    double? estimatedOneRepMax,
    int? repsAtMaxWeight,
    DateTime? achievedAt,
  }) => PersonalRecord(
    exerciseId: exerciseId ?? this.exerciseId,
    maxWeightKg: maxWeightKg ?? this.maxWeightKg,
    estimatedOneRepMax: estimatedOneRepMax ?? this.estimatedOneRepMax,
    repsAtMaxWeight: repsAtMaxWeight ?? this.repsAtMaxWeight,
    achievedAt: achievedAt ?? this.achievedAt,
  );
  PersonalRecord copyWithCompanion(PersonalRecordsCompanion data) {
    return PersonalRecord(
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      maxWeightKg: data.maxWeightKg.present
          ? data.maxWeightKg.value
          : this.maxWeightKg,
      estimatedOneRepMax: data.estimatedOneRepMax.present
          ? data.estimatedOneRepMax.value
          : this.estimatedOneRepMax,
      repsAtMaxWeight: data.repsAtMaxWeight.present
          ? data.repsAtMaxWeight.value
          : this.repsAtMaxWeight,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecord(')
          ..write('exerciseId: $exerciseId, ')
          ..write('maxWeightKg: $maxWeightKg, ')
          ..write('estimatedOneRepMax: $estimatedOneRepMax, ')
          ..write('repsAtMaxWeight: $repsAtMaxWeight, ')
          ..write('achievedAt: $achievedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    exerciseId,
    maxWeightKg,
    estimatedOneRepMax,
    repsAtMaxWeight,
    achievedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalRecord &&
          other.exerciseId == this.exerciseId &&
          other.maxWeightKg == this.maxWeightKg &&
          other.estimatedOneRepMax == this.estimatedOneRepMax &&
          other.repsAtMaxWeight == this.repsAtMaxWeight &&
          other.achievedAt == this.achievedAt);
}

class PersonalRecordsCompanion extends UpdateCompanion<PersonalRecord> {
  final Value<String> exerciseId;
  final Value<double> maxWeightKg;
  final Value<double> estimatedOneRepMax;
  final Value<int> repsAtMaxWeight;
  final Value<DateTime> achievedAt;
  final Value<int> rowid;
  const PersonalRecordsCompanion({
    this.exerciseId = const Value.absent(),
    this.maxWeightKg = const Value.absent(),
    this.estimatedOneRepMax = const Value.absent(),
    this.repsAtMaxWeight = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalRecordsCompanion.insert({
    required String exerciseId,
    required double maxWeightKg,
    required double estimatedOneRepMax,
    required int repsAtMaxWeight,
    required DateTime achievedAt,
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       maxWeightKg = Value(maxWeightKg),
       estimatedOneRepMax = Value(estimatedOneRepMax),
       repsAtMaxWeight = Value(repsAtMaxWeight),
       achievedAt = Value(achievedAt);
  static Insertable<PersonalRecord> custom({
    Expression<String>? exerciseId,
    Expression<double>? maxWeightKg,
    Expression<double>? estimatedOneRepMax,
    Expression<int>? repsAtMaxWeight,
    Expression<DateTime>? achievedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (maxWeightKg != null) 'max_weight_kg': maxWeightKg,
      if (estimatedOneRepMax != null)
        'estimated_one_rep_max': estimatedOneRepMax,
      if (repsAtMaxWeight != null) 'reps_at_max_weight': repsAtMaxWeight,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalRecordsCompanion copyWith({
    Value<String>? exerciseId,
    Value<double>? maxWeightKg,
    Value<double>? estimatedOneRepMax,
    Value<int>? repsAtMaxWeight,
    Value<DateTime>? achievedAt,
    Value<int>? rowid,
  }) {
    return PersonalRecordsCompanion(
      exerciseId: exerciseId ?? this.exerciseId,
      maxWeightKg: maxWeightKg ?? this.maxWeightKg,
      estimatedOneRepMax: estimatedOneRepMax ?? this.estimatedOneRepMax,
      repsAtMaxWeight: repsAtMaxWeight ?? this.repsAtMaxWeight,
      achievedAt: achievedAt ?? this.achievedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (maxWeightKg.present) {
      map['max_weight_kg'] = Variable<double>(maxWeightKg.value);
    }
    if (estimatedOneRepMax.present) {
      map['estimated_one_rep_max'] = Variable<double>(estimatedOneRepMax.value);
    }
    if (repsAtMaxWeight.present) {
      map['reps_at_max_weight'] = Variable<int>(repsAtMaxWeight.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalRecordsCompanion(')
          ..write('exerciseId: $exerciseId, ')
          ..write('maxWeightKg: $maxWeightKg, ')
          ..write('estimatedOneRepMax: $estimatedOneRepMax, ')
          ..write('repsAtMaxWeight: $repsAtMaxWeight, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Attribute, String> attribute =
      GeneratedColumn<String>(
        'attribute',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Attribute>($ActivitiesTable.$converterattribute);
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<double> durationMinutes = GeneratedColumn<double>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<double> intensity = GeneratedColumn<double>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    attribute,
    durationMinutes,
    intensity,
    timestamp,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      attribute: $ActivitiesTable.$converterattribute.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}attribute'],
        )!,
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duration_minutes'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}intensity'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Attribute, String, String> $converterattribute =
      const EnumNameConverter<Attribute>(Attribute.values);
}

class Activity extends DataClass implements Insertable<Activity> {
  final String id;
  final String type;
  final Attribute attribute;
  final double durationMinutes;
  final double intensity;
  final DateTime timestamp;
  final String? notes;
  const Activity({
    required this.id,
    required this.type,
    required this.attribute,
    required this.durationMinutes,
    required this.intensity,
    required this.timestamp,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    {
      map['attribute'] = Variable<String>(
        $ActivitiesTable.$converterattribute.toSql(attribute),
      );
    }
    map['duration_minutes'] = Variable<double>(durationMinutes);
    map['intensity'] = Variable<double>(intensity);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      type: Value(type),
      attribute: Value(attribute),
      durationMinutes: Value(durationMinutes),
      intensity: Value(intensity),
      timestamp: Value(timestamp),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      attribute: $ActivitiesTable.$converterattribute.fromJson(
        serializer.fromJson<String>(json['attribute']),
      ),
      durationMinutes: serializer.fromJson<double>(json['durationMinutes']),
      intensity: serializer.fromJson<double>(json['intensity']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'attribute': serializer.toJson<String>(
        $ActivitiesTable.$converterattribute.toJson(attribute),
      ),
      'durationMinutes': serializer.toJson<double>(durationMinutes),
      'intensity': serializer.toJson<double>(intensity),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Activity copyWith({
    String? id,
    String? type,
    Attribute? attribute,
    double? durationMinutes,
    double? intensity,
    DateTime? timestamp,
    Value<String?> notes = const Value.absent(),
  }) => Activity(
    id: id ?? this.id,
    type: type ?? this.type,
    attribute: attribute ?? this.attribute,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    intensity: intensity ?? this.intensity,
    timestamp: timestamp ?? this.timestamp,
    notes: notes.present ? notes.value : this.notes,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      attribute: data.attribute.present ? data.attribute.value : this.attribute,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('attribute: $attribute, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('intensity: $intensity, ')
          ..write('timestamp: $timestamp, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    attribute,
    durationMinutes,
    intensity,
    timestamp,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.type == this.type &&
          other.attribute == this.attribute &&
          other.durationMinutes == this.durationMinutes &&
          other.intensity == this.intensity &&
          other.timestamp == this.timestamp &&
          other.notes == this.notes);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<String> id;
  final Value<String> type;
  final Value<Attribute> attribute;
  final Value<double> durationMinutes;
  final Value<double> intensity;
  final Value<DateTime> timestamp;
  final Value<String?> notes;
  final Value<int> rowid;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.attribute = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.intensity = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    required String id,
    required String type,
    required Attribute attribute,
    required double durationMinutes,
    this.intensity = const Value.absent(),
    required DateTime timestamp,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       attribute = Value(attribute),
       durationMinutes = Value(durationMinutes),
       timestamp = Value(timestamp);
  static Insertable<Activity> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? attribute,
    Expression<double>? durationMinutes,
    Expression<double>? intensity,
    Expression<DateTime>? timestamp,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (attribute != null) 'attribute': attribute,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (intensity != null) 'intensity': intensity,
      if (timestamp != null) 'timestamp': timestamp,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<Attribute>? attribute,
    Value<double>? durationMinutes,
    Value<double>? intensity,
    Value<DateTime>? timestamp,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      attribute: attribute ?? this.attribute,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensity: intensity ?? this.intensity,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (attribute.present) {
      map['attribute'] = Variable<String>(
        $ActivitiesTable.$converterattribute.toSql(attribute.value),
      );
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<double>(durationMinutes.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<double>(intensity.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('attribute: $attribute, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('intensity: $intensity, ')
          ..write('timestamp: $timestamp, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $XpLedgerTable extends XpLedger
    with TableInfo<$XpLedgerTable, XpLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Attribute, String> attribute =
      GeneratedColumn<String>(
        'attribute',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Attribute>($XpLedgerTable.$converterattribute);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<XpSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<XpSource>($XpLedgerTable.$convertersource);
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    attribute,
    amount,
    source,
    timestamp,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<XpLedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  XpLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpLedgerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      attribute: $XpLedgerTable.$converterattribute.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}attribute'],
        )!,
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      source: $XpLedgerTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $XpLedgerTable createAlias(String alias) {
    return $XpLedgerTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Attribute, String, String> $converterattribute =
      const EnumNameConverter<Attribute>(Attribute.values);
  static JsonTypeConverter2<XpSource, String, String> $convertersource =
      const EnumNameConverter<XpSource>(XpSource.values);
}

class XpLedgerData extends DataClass implements Insertable<XpLedgerData> {
  final String id;
  final Attribute attribute;
  final double amount;
  final XpSource source;
  final DateTime timestamp;
  final String? description;
  const XpLedgerData({
    required this.id,
    required this.attribute,
    required this.amount,
    required this.source,
    required this.timestamp,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['attribute'] = Variable<String>(
        $XpLedgerTable.$converterattribute.toSql(attribute),
      );
    }
    map['amount'] = Variable<double>(amount);
    {
      map['source'] = Variable<String>(
        $XpLedgerTable.$convertersource.toSql(source),
      );
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  XpLedgerCompanion toCompanion(bool nullToAbsent) {
    return XpLedgerCompanion(
      id: Value(id),
      attribute: Value(attribute),
      amount: Value(amount),
      source: Value(source),
      timestamp: Value(timestamp),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory XpLedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpLedgerData(
      id: serializer.fromJson<String>(json['id']),
      attribute: $XpLedgerTable.$converterattribute.fromJson(
        serializer.fromJson<String>(json['attribute']),
      ),
      amount: serializer.fromJson<double>(json['amount']),
      source: $XpLedgerTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'attribute': serializer.toJson<String>(
        $XpLedgerTable.$converterattribute.toJson(attribute),
      ),
      'amount': serializer.toJson<double>(amount),
      'source': serializer.toJson<String>(
        $XpLedgerTable.$convertersource.toJson(source),
      ),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'description': serializer.toJson<String?>(description),
    };
  }

  XpLedgerData copyWith({
    String? id,
    Attribute? attribute,
    double? amount,
    XpSource? source,
    DateTime? timestamp,
    Value<String?> description = const Value.absent(),
  }) => XpLedgerData(
    id: id ?? this.id,
    attribute: attribute ?? this.attribute,
    amount: amount ?? this.amount,
    source: source ?? this.source,
    timestamp: timestamp ?? this.timestamp,
    description: description.present ? description.value : this.description,
  );
  XpLedgerData copyWithCompanion(XpLedgerCompanion data) {
    return XpLedgerData(
      id: data.id.present ? data.id.value : this.id,
      attribute: data.attribute.present ? data.attribute.value : this.attribute,
      amount: data.amount.present ? data.amount.value : this.amount,
      source: data.source.present ? data.source.value : this.source,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpLedgerData(')
          ..write('id: $id, ')
          ..write('attribute: $attribute, ')
          ..write('amount: $amount, ')
          ..write('source: $source, ')
          ..write('timestamp: $timestamp, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, attribute, amount, source, timestamp, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpLedgerData &&
          other.id == this.id &&
          other.attribute == this.attribute &&
          other.amount == this.amount &&
          other.source == this.source &&
          other.timestamp == this.timestamp &&
          other.description == this.description);
}

class XpLedgerCompanion extends UpdateCompanion<XpLedgerData> {
  final Value<String> id;
  final Value<Attribute> attribute;
  final Value<double> amount;
  final Value<XpSource> source;
  final Value<DateTime> timestamp;
  final Value<String?> description;
  final Value<int> rowid;
  const XpLedgerCompanion({
    this.id = const Value.absent(),
    this.attribute = const Value.absent(),
    this.amount = const Value.absent(),
    this.source = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  XpLedgerCompanion.insert({
    required String id,
    required Attribute attribute,
    required double amount,
    required XpSource source,
    required DateTime timestamp,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       attribute = Value(attribute),
       amount = Value(amount),
       source = Value(source),
       timestamp = Value(timestamp);
  static Insertable<XpLedgerData> custom({
    Expression<String>? id,
    Expression<String>? attribute,
    Expression<double>? amount,
    Expression<String>? source,
    Expression<DateTime>? timestamp,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attribute != null) 'attribute': attribute,
      if (amount != null) 'amount': amount,
      if (source != null) 'source': source,
      if (timestamp != null) 'timestamp': timestamp,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  XpLedgerCompanion copyWith({
    Value<String>? id,
    Value<Attribute>? attribute,
    Value<double>? amount,
    Value<XpSource>? source,
    Value<DateTime>? timestamp,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return XpLedgerCompanion(
      id: id ?? this.id,
      attribute: attribute ?? this.attribute,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      timestamp: timestamp ?? this.timestamp,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (attribute.present) {
      map['attribute'] = Variable<String>(
        $XpLedgerTable.$converterattribute.toSql(attribute.value),
      );
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $XpLedgerTable.$convertersource.toSql(source.value),
      );
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpLedgerCompanion(')
          ..write('id: $id, ')
          ..write('attribute: $attribute, ')
          ..write('amount: $amount, ')
          ..write('source: $source, ')
          ..write('timestamp: $timestamp, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyQuestsTableTable extends DailyQuestsTable
    with TableInfo<$DailyQuestsTableTable, DailyQuestsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyQuestsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateStrMeta = const VerificationMeta(
    'dateStr',
  );
  @override
  late final GeneratedColumn<String> dateStr = GeneratedColumn<String>(
    'date_str',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Attribute, String>
  targetAttribute = GeneratedColumn<String>(
    'target_attribute',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Attribute>($DailyQuestsTableTable.$convertertargetAttribute);
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentValueMeta = const VerificationMeta(
    'currentValue',
  );
  @override
  late final GeneratedColumn<double> currentValue = GeneratedColumn<double>(
    'current_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bonusXpMeta = const VerificationMeta(
    'bonusXp',
  );
  @override
  late final GeneratedColumn<double> bonusXp = GeneratedColumn<double>(
    'bonus_xp',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grantsInspirationMeta = const VerificationMeta(
    'grantsInspiration',
  );
  @override
  late final GeneratedColumn<bool> grantsInspiration = GeneratedColumn<bool>(
    'grants_inspiration',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("grants_inspiration" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateStr,
    title,
    description,
    targetAttribute,
    targetValue,
    currentValue,
    unit,
    bonusXp,
    grantsInspiration,
    isCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_quests_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyQuestsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_str')) {
      context.handle(
        _dateStrMeta,
        dateStr.isAcceptableOrUnknown(data['date_str']!, _dateStrMeta),
      );
    } else if (isInserting) {
      context.missing(_dateStrMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
        _currentValueMeta,
        currentValue.isAcceptableOrUnknown(
          data['current_value']!,
          _currentValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentValueMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('bonus_xp')) {
      context.handle(
        _bonusXpMeta,
        bonusXp.isAcceptableOrUnknown(data['bonus_xp']!, _bonusXpMeta),
      );
    } else if (isInserting) {
      context.missing(_bonusXpMeta);
    }
    if (data.containsKey('grants_inspiration')) {
      context.handle(
        _grantsInspirationMeta,
        grantsInspiration.isAcceptableOrUnknown(
          data['grants_inspiration']!,
          _grantsInspirationMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyQuestsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyQuestsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dateStr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_str'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      targetAttribute: $DailyQuestsTableTable.$convertertargetAttribute.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target_attribute'],
        )!,
      ),
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      )!,
      currentValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_value'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      bonusXp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bonus_xp'],
      )!,
      grantsInspiration: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}grants_inspiration'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
    );
  }

  @override
  $DailyQuestsTableTable createAlias(String alias) {
    return $DailyQuestsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Attribute, String, String>
  $convertertargetAttribute = const EnumNameConverter<Attribute>(
    Attribute.values,
  );
}

class DailyQuestsTableData extends DataClass
    implements Insertable<DailyQuestsTableData> {
  final String id;
  final String dateStr;
  final String title;
  final String description;
  final Attribute targetAttribute;
  final double targetValue;
  final double currentValue;
  final String unit;
  final double bonusXp;
  final bool grantsInspiration;
  final bool isCompleted;
  const DailyQuestsTableData({
    required this.id,
    required this.dateStr,
    required this.title,
    required this.description,
    required this.targetAttribute,
    required this.targetValue,
    required this.currentValue,
    required this.unit,
    required this.bonusXp,
    required this.grantsInspiration,
    required this.isCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date_str'] = Variable<String>(dateStr);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    {
      map['target_attribute'] = Variable<String>(
        $DailyQuestsTableTable.$convertertargetAttribute.toSql(targetAttribute),
      );
    }
    map['target_value'] = Variable<double>(targetValue);
    map['current_value'] = Variable<double>(currentValue);
    map['unit'] = Variable<String>(unit);
    map['bonus_xp'] = Variable<double>(bonusXp);
    map['grants_inspiration'] = Variable<bool>(grantsInspiration);
    map['is_completed'] = Variable<bool>(isCompleted);
    return map;
  }

  DailyQuestsTableCompanion toCompanion(bool nullToAbsent) {
    return DailyQuestsTableCompanion(
      id: Value(id),
      dateStr: Value(dateStr),
      title: Value(title),
      description: Value(description),
      targetAttribute: Value(targetAttribute),
      targetValue: Value(targetValue),
      currentValue: Value(currentValue),
      unit: Value(unit),
      bonusXp: Value(bonusXp),
      grantsInspiration: Value(grantsInspiration),
      isCompleted: Value(isCompleted),
    );
  }

  factory DailyQuestsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyQuestsTableData(
      id: serializer.fromJson<String>(json['id']),
      dateStr: serializer.fromJson<String>(json['dateStr']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      targetAttribute: $DailyQuestsTableTable.$convertertargetAttribute
          .fromJson(serializer.fromJson<String>(json['targetAttribute'])),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      currentValue: serializer.fromJson<double>(json['currentValue']),
      unit: serializer.fromJson<String>(json['unit']),
      bonusXp: serializer.fromJson<double>(json['bonusXp']),
      grantsInspiration: serializer.fromJson<bool>(json['grantsInspiration']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dateStr': serializer.toJson<String>(dateStr),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'targetAttribute': serializer.toJson<String>(
        $DailyQuestsTableTable.$convertertargetAttribute.toJson(
          targetAttribute,
        ),
      ),
      'targetValue': serializer.toJson<double>(targetValue),
      'currentValue': serializer.toJson<double>(currentValue),
      'unit': serializer.toJson<String>(unit),
      'bonusXp': serializer.toJson<double>(bonusXp),
      'grantsInspiration': serializer.toJson<bool>(grantsInspiration),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  DailyQuestsTableData copyWith({
    String? id,
    String? dateStr,
    String? title,
    String? description,
    Attribute? targetAttribute,
    double? targetValue,
    double? currentValue,
    String? unit,
    double? bonusXp,
    bool? grantsInspiration,
    bool? isCompleted,
  }) => DailyQuestsTableData(
    id: id ?? this.id,
    dateStr: dateStr ?? this.dateStr,
    title: title ?? this.title,
    description: description ?? this.description,
    targetAttribute: targetAttribute ?? this.targetAttribute,
    targetValue: targetValue ?? this.targetValue,
    currentValue: currentValue ?? this.currentValue,
    unit: unit ?? this.unit,
    bonusXp: bonusXp ?? this.bonusXp,
    grantsInspiration: grantsInspiration ?? this.grantsInspiration,
    isCompleted: isCompleted ?? this.isCompleted,
  );
  DailyQuestsTableData copyWithCompanion(DailyQuestsTableCompanion data) {
    return DailyQuestsTableData(
      id: data.id.present ? data.id.value : this.id,
      dateStr: data.dateStr.present ? data.dateStr.value : this.dateStr,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      targetAttribute: data.targetAttribute.present
          ? data.targetAttribute.value
          : this.targetAttribute,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      unit: data.unit.present ? data.unit.value : this.unit,
      bonusXp: data.bonusXp.present ? data.bonusXp.value : this.bonusXp,
      grantsInspiration: data.grantsInspiration.present
          ? data.grantsInspiration.value
          : this.grantsInspiration,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestsTableData(')
          ..write('id: $id, ')
          ..write('dateStr: $dateStr, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('targetAttribute: $targetAttribute, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('unit: $unit, ')
          ..write('bonusXp: $bonusXp, ')
          ..write('grantsInspiration: $grantsInspiration, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dateStr,
    title,
    description,
    targetAttribute,
    targetValue,
    currentValue,
    unit,
    bonusXp,
    grantsInspiration,
    isCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyQuestsTableData &&
          other.id == this.id &&
          other.dateStr == this.dateStr &&
          other.title == this.title &&
          other.description == this.description &&
          other.targetAttribute == this.targetAttribute &&
          other.targetValue == this.targetValue &&
          other.currentValue == this.currentValue &&
          other.unit == this.unit &&
          other.bonusXp == this.bonusXp &&
          other.grantsInspiration == this.grantsInspiration &&
          other.isCompleted == this.isCompleted);
}

class DailyQuestsTableCompanion extends UpdateCompanion<DailyQuestsTableData> {
  final Value<String> id;
  final Value<String> dateStr;
  final Value<String> title;
  final Value<String> description;
  final Value<Attribute> targetAttribute;
  final Value<double> targetValue;
  final Value<double> currentValue;
  final Value<String> unit;
  final Value<double> bonusXp;
  final Value<bool> grantsInspiration;
  final Value<bool> isCompleted;
  final Value<int> rowid;
  const DailyQuestsTableCompanion({
    this.id = const Value.absent(),
    this.dateStr = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.targetAttribute = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.unit = const Value.absent(),
    this.bonusXp = const Value.absent(),
    this.grantsInspiration = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyQuestsTableCompanion.insert({
    required String id,
    required String dateStr,
    required String title,
    required String description,
    required Attribute targetAttribute,
    required double targetValue,
    required double currentValue,
    required String unit,
    required double bonusXp,
    this.grantsInspiration = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dateStr = Value(dateStr),
       title = Value(title),
       description = Value(description),
       targetAttribute = Value(targetAttribute),
       targetValue = Value(targetValue),
       currentValue = Value(currentValue),
       unit = Value(unit),
       bonusXp = Value(bonusXp);
  static Insertable<DailyQuestsTableData> custom({
    Expression<String>? id,
    Expression<String>? dateStr,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? targetAttribute,
    Expression<double>? targetValue,
    Expression<double>? currentValue,
    Expression<String>? unit,
    Expression<double>? bonusXp,
    Expression<bool>? grantsInspiration,
    Expression<bool>? isCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateStr != null) 'date_str': dateStr,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (targetAttribute != null) 'target_attribute': targetAttribute,
      if (targetValue != null) 'target_value': targetValue,
      if (currentValue != null) 'current_value': currentValue,
      if (unit != null) 'unit': unit,
      if (bonusXp != null) 'bonus_xp': bonusXp,
      if (grantsInspiration != null) 'grants_inspiration': grantsInspiration,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyQuestsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? dateStr,
    Value<String>? title,
    Value<String>? description,
    Value<Attribute>? targetAttribute,
    Value<double>? targetValue,
    Value<double>? currentValue,
    Value<String>? unit,
    Value<double>? bonusXp,
    Value<bool>? grantsInspiration,
    Value<bool>? isCompleted,
    Value<int>? rowid,
  }) {
    return DailyQuestsTableCompanion(
      id: id ?? this.id,
      dateStr: dateStr ?? this.dateStr,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAttribute: targetAttribute ?? this.targetAttribute,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      bonusXp: bonusXp ?? this.bonusXp,
      grantsInspiration: grantsInspiration ?? this.grantsInspiration,
      isCompleted: isCompleted ?? this.isCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dateStr.present) {
      map['date_str'] = Variable<String>(dateStr.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (targetAttribute.present) {
      map['target_attribute'] = Variable<String>(
        $DailyQuestsTableTable.$convertertargetAttribute.toSql(
          targetAttribute.value,
        ),
      );
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<double>(currentValue.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (bonusXp.present) {
      map['bonus_xp'] = Variable<double>(bonusXp.value);
    }
    if (grantsInspiration.present) {
      map['grants_inspiration'] = Variable<bool>(grantsInspiration.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestsTableCompanion(')
          ..write('id: $id, ')
          ..write('dateStr: $dateStr, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('targetAttribute: $targetAttribute, ')
          ..write('targetValue: $targetValue, ')
          ..write('currentValue: $currentValue, ')
          ..write('unit: $unit, ')
          ..write('bonusXp: $bonusXp, ')
          ..write('grantsInspiration: $grantsInspiration, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $RoutineExercisesTable routineExercises = $RoutineExercisesTable(
    this,
  );
  late final $HeroesTable heroes = $HeroesTable(this);
  late final $DailyHealthLogsTable dailyHealthLogs = $DailyHealthLogsTable(
    this,
  );
  late final $ArenaProgressTable arenaProgress = $ArenaProgressTable(this);
  late final $DailyArenaLogsTable dailyArenaLogs = $DailyArenaLogsTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $PersonalRecordsTable personalRecords = $PersonalRecordsTable(
    this,
  );
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $XpLedgerTable xpLedger = $XpLedgerTable(this);
  late final $DailyQuestsTableTable dailyQuestsTable = $DailyQuestsTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routines,
    exercises,
    routineExercises,
    heroes,
    dailyHealthLogs,
    arenaProgress,
    dailyArenaLogs,
    workoutSessions,
    workoutSets,
    personalRecords,
    activities,
    xpLedger,
    dailyQuestsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_exercises', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  required String id,
  required String name,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, RoutineRow> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineExercisesTable, List<RoutineExerciseRow>>
  _routineExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineExercises,
    aliasName: 'routines__id__routine_exercises__routine_id',
  );

  $$RoutineExercisesTableProcessedTableManager get routineExercisesRefs {
    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
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

  Expression<bool> routineExercisesRefs(
    Expression<bool> Function($$RoutineExercisesTableFilterComposer f) f,
  ) {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
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

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> routineExercisesRefs<T extends Object>(
    Expression<T> Function($$RoutineExercisesTableAnnotationComposer a) f,
  ) {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          RoutineRow,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (RoutineRow, $$RoutinesTableReferences),
          RoutineRow,
          PrefetchHooks Function({bool routineExercisesRefs})
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutinesTable, RoutineRow>(table),
                  $$RoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (routineExercisesRefs) db.routineExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (routineExercisesRefs)
                    await $_getPrefetchedDataByColumns<
                      RoutineRow,
                      $RoutinesTable,
                      RoutineExerciseRow,
                      $RoutineExercisesTable
                    >(
                      currentTable: table,
                      referencedTable: $$RoutinesTableReferences
                          ._routineExercisesRefsTable(db),
                      managerFromTypedResult: (p0) => $$RoutinesTableReferences(
                        db,
                        table,
                        p0,
                      ).routineExercisesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'routine_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      RoutineRow,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (RoutineRow, $$RoutinesTableReferences),
      RoutineRow,
      PrefetchHooks Function({bool routineExercisesRefs})
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  required String id,
  required String name,
  required MuscleGroup muscleGroup,
  required Equipment equipment,
  required Attribute attribute,
  Value<SetTracking> tracking,
  Value<bool> isCustom,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<MuscleGroup> muscleGroup,
  Value<Equipment> equipment,
  Value<Attribute> attribute,
  Value<SetTracking> tracking,
  Value<bool> isCustom,
  Value<int> rowid,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RoutineExercisesTable, List<RoutineExerciseRow>>
  _routineExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineExercises,
    aliasName: 'exercises__id__routine_exercises__exercise_id',
  );

  $$RoutineExercisesTableProcessedTableManager get routineExercisesRefs {
    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'exercises__id__workout_sets__exercise_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PersonalRecordsTable, List<PersonalRecord>>
  _personalRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personalRecords,
    aliasName: 'exercises__id__personal_records__exercise_id',
  );

  $$PersonalRecordsTableProcessedTableManager get personalRecordsRefs {
    final manager = $$PersonalRecordsTableTableManager(
      $_db,
      $_db.personalRecords,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _personalRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MuscleGroup, MuscleGroup, String>
  get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Equipment, Equipment, String> get equipment =>
      $composableBuilder(
        column: $table.equipment,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Attribute, Attribute, String> get attribute =>
      $composableBuilder(
        column: $table.attribute,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<SetTracking, SetTracking, String>
  get tracking => $composableBuilder(
    column: $table.tracking,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> routineExercisesRefs(
    Expression<bool> Function($$RoutineExercisesTableFilterComposer f) f,
  ) {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> personalRecordsRefs(
    Expression<bool> Function($$PersonalRecordsTableFilterComposer f) f,
  ) {
    final $$PersonalRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalRecords,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRecordsTableFilterComposer(
            $db: $db,
            $table: $db.personalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attribute => $composableBuilder(
    column: $table.attribute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tracking => $composableBuilder(
    column: $table.tracking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MuscleGroup, String> get muscleGroup =>
      $composableBuilder(
        column: $table.muscleGroup,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Equipment, String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Attribute, String> get attribute =>
      $composableBuilder(column: $table.attribute, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SetTracking, String> get tracking =>
      $composableBuilder(column: $table.tracking, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> routineExercisesRefs<T extends Object>(
    Expression<T> Function($$RoutineExercisesTableAnnotationComposer a) f,
  ) {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> personalRecordsRefs<T extends Object>(
    Expression<T> Function($$PersonalRecordsTableAnnotationComposer a) f,
  ) {
    final $$PersonalRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personalRecords,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonalRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.personalRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool routineExercisesRefs,
            bool workoutSetsRefs,
            bool personalRecordsRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<MuscleGroup> muscleGroup = const Value.absent(),
                Value<Equipment> equipment = const Value.absent(),
                Value<Attribute> attribute = const Value.absent(),
                Value<SetTracking> tracking = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                muscleGroup: muscleGroup,
                equipment: equipment,
                attribute: attribute,
                tracking: tracking,
                isCustom: isCustom,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required MuscleGroup muscleGroup,
                required Equipment equipment,
                required Attribute attribute,
                Value<SetTracking> tracking = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                muscleGroup: muscleGroup,
                equipment: equipment,
                attribute: attribute,
                tracking: tracking,
                isCustom: isCustom,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                routineExercisesRefs = false,
                workoutSetsRefs = false,
                personalRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (routineExercisesRefs) db.routineExercises,
                    if (workoutSetsRefs) db.workoutSets,
                    if (personalRecordsRefs) db.personalRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (routineExercisesRefs)
                        await $_getPrefetchedDataByColumns<
                          Exercise,
                          $ExercisesTable,
                          RoutineExerciseRow,
                          $RoutineExercisesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._routineExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).routineExercisesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'exercise_id',
                          typedResults: items,
                        ),
                      if (workoutSetsRefs)
                        await $_getPrefetchedDataByColumns<
                          Exercise,
                          $ExercisesTable,
                          WorkoutSet,
                          $WorkoutSetsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'exercise_id',
                          typedResults: items,
                        ),
                      if (personalRecordsRefs)
                        await $_getPrefetchedDataByColumns<
                          Exercise,
                          $ExercisesTable,
                          PersonalRecord,
                          $PersonalRecordsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._personalRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).personalRecordsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'exercise_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({
        bool routineExercisesRefs,
        bool workoutSetsRefs,
        bool personalRecordsRefs,
      })
    >;
typedef $$RoutineExercisesTableCreateCompanionBuilder =
    RoutineExercisesCompanion Function({
      Value<int> id,
      required String routineId,
      required int position,
      required String exerciseId,
      required int sets,
      Value<int?> repsMin,
      Value<int?> repsMax,
      Value<int?> durationSeconds,
      Value<bool> toFailure,
      Value<int> restSeconds,
    });
typedef $$RoutineExercisesTableUpdateCompanionBuilder =
    RoutineExercisesCompanion Function({
      Value<int> id,
      Value<String> routineId,
      Value<int> position,
      Value<String> exerciseId,
      Value<int> sets,
      Value<int?> repsMin,
      Value<int?> repsMax,
      Value<int?> durationSeconds,
      Value<bool> toFailure,
      Value<int> restSeconds,
    });

final class $$RoutineExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RoutineExercisesTable,
          RoutineExerciseRow
        > {
  $$RoutineExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('routine_exercises__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('routine_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RoutineExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableFilterComposer({
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

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsMin => $composableBuilder(
    column: $table.repsMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsMax => $composableBuilder(
    column: $table.repsMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get toFailure => $composableBuilder(
    column: $table.toFailure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableOrderingComposer({
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

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsMin => $composableBuilder(
    column: $table.repsMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsMax => $composableBuilder(
    column: $table.repsMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get toFailure => $composableBuilder(
    column: $table.toFailure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get repsMin =>
      $composableBuilder(column: $table.repsMin, builder: (column) => column);

  GeneratedColumn<int> get repsMax =>
      $composableBuilder(column: $table.repsMax, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get toFailure =>
      $composableBuilder(column: $table.toFailure, builder: (column) => column);

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineExercisesTable,
          RoutineExerciseRow,
          $$RoutineExercisesTableFilterComposer,
          $$RoutineExercisesTableOrderingComposer,
          $$RoutineExercisesTableAnnotationComposer,
          $$RoutineExercisesTableCreateCompanionBuilder,
          $$RoutineExercisesTableUpdateCompanionBuilder,
          (RoutineExerciseRow, $$RoutineExercisesTableReferences),
          RoutineExerciseRow,
          PrefetchHooks Function({bool routineId, bool exerciseId})
        > {
  $$RoutineExercisesTableTableManager(
    _$AppDatabase db,
    $RoutineExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> routineId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sets = const Value.absent(),
                Value<int?> repsMin = const Value.absent(),
                Value<int?> repsMax = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<bool> toFailure = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
              }) => RoutineExercisesCompanion(
                id: id,
                routineId: routineId,
                position: position,
                exerciseId: exerciseId,
                sets: sets,
                repsMin: repsMin,
                repsMax: repsMax,
                durationSeconds: durationSeconds,
                toFailure: toFailure,
                restSeconds: restSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String routineId,
                required int position,
                required String exerciseId,
                required int sets,
                Value<int?> repsMin = const Value.absent(),
                Value<int?> repsMax = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<bool> toFailure = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
              }) => RoutineExercisesCompanion.insert(
                id: id,
                routineId: routineId,
                position: position,
                exerciseId: exerciseId,
                sets: sets,
                repsMin: repsMin,
                repsMax: repsMax,
                durationSeconds: durationSeconds,
                toFailure: toFailure,
                restSeconds: restSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutineExercisesTable, RoutineExerciseRow>(
                    table,
                  ),
                  $$RoutineExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({routineId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (routineId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.routineId,
                        referencedTable: $$RoutineExercisesTableReferences
                            ._routineIdTable(db),
                        referencedColumn: $$RoutineExercisesTableReferences
                            ._routineIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$RoutineExercisesTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$RoutineExercisesTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RoutineExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineExercisesTable,
      RoutineExerciseRow,
      $$RoutineExercisesTableFilterComposer,
      $$RoutineExercisesTableOrderingComposer,
      $$RoutineExercisesTableAnnotationComposer,
      $$RoutineExercisesTableCreateCompanionBuilder,
      $$RoutineExercisesTableUpdateCompanionBuilder,
      (RoutineExerciseRow, $$RoutineExercisesTableReferences),
      RoutineExerciseRow,
      PrefetchHooks Function({bool routineId, bool exerciseId})
    >;
typedef $$HeroesTableCreateCompanionBuilder = HeroesCompanion Function({
  Value<int> id,
  required String name,
  required HeroForm form,
  required HeroOrigin origin,
  Value<String?> oath,
  required DateTime createdAt,
  Value<String?> customOriginName,
  Value<String?> customOriginStory,
  Value<int> weeklyGoal,
  Value<int> waterGoalCups,
  Value<String?> equippedTitleId,
  Value<String?> equippedCosmeticId,
  Value<CharacterClass?> selectedClass,
  Value<String?> appearance,
});
typedef $$HeroesTableUpdateCompanionBuilder = HeroesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<HeroForm> form,
  Value<HeroOrigin> origin,
  Value<String?> oath,
  Value<DateTime> createdAt,
  Value<String?> customOriginName,
  Value<String?> customOriginStory,
  Value<int> weeklyGoal,
  Value<int> waterGoalCups,
  Value<String?> equippedTitleId,
  Value<String?> equippedCosmeticId,
  Value<CharacterClass?> selectedClass,
  Value<String?> appearance,
});

class $$HeroesTableFilterComposer
    extends Composer<_$AppDatabase, $HeroesTable> {
  $$HeroesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<HeroForm, HeroForm, String> get form =>
      $composableBuilder(
        column: $table.form,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<HeroOrigin, HeroOrigin, String> get origin =>
      $composableBuilder(
        column: $table.origin,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get oath => $composableBuilder(
    column: $table.oath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customOriginName => $composableBuilder(
    column: $table.customOriginName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customOriginStory => $composableBuilder(
    column: $table.customOriginStory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyGoal => $composableBuilder(
    column: $table.weeklyGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterGoalCups => $composableBuilder(
    column: $table.waterGoalCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equippedTitleId => $composableBuilder(
    column: $table.equippedTitleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equippedCosmeticId => $composableBuilder(
    column: $table.equippedCosmeticId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CharacterClass?, CharacterClass, String>
  get selectedClass => $composableBuilder(
    column: $table.selectedClass,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HeroesTableOrderingComposer
    extends Composer<_$AppDatabase, $HeroesTable> {
  $$HeroesTableOrderingComposer({
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

  ColumnOrderings<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origin => $composableBuilder(
    column: $table.origin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oath => $composableBuilder(
    column: $table.oath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customOriginName => $composableBuilder(
    column: $table.customOriginName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customOriginStory => $composableBuilder(
    column: $table.customOriginStory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyGoal => $composableBuilder(
    column: $table.weeklyGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterGoalCups => $composableBuilder(
    column: $table.waterGoalCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equippedTitleId => $composableBuilder(
    column: $table.equippedTitleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equippedCosmeticId => $composableBuilder(
    column: $table.equippedCosmeticId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedClass => $composableBuilder(
    column: $table.selectedClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HeroesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HeroesTable> {
  $$HeroesTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<HeroForm, String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HeroOrigin, String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get oath =>
      $composableBuilder(column: $table.oath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get customOriginName => $composableBuilder(
    column: $table.customOriginName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customOriginStory => $composableBuilder(
    column: $table.customOriginStory,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyGoal => $composableBuilder(
    column: $table.weeklyGoal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get waterGoalCups => $composableBuilder(
    column: $table.waterGoalCups,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equippedTitleId => $composableBuilder(
    column: $table.equippedTitleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equippedCosmeticId => $composableBuilder(
    column: $table.equippedCosmeticId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CharacterClass?, String> get selectedClass =>
      $composableBuilder(
        column: $table.selectedClass,
        builder: (column) => column,
      );

  GeneratedColumn<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => column,
  );
}

class $$HeroesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HeroesTable,
          HeroRow,
          $$HeroesTableFilterComposer,
          $$HeroesTableOrderingComposer,
          $$HeroesTableAnnotationComposer,
          $$HeroesTableCreateCompanionBuilder,
          $$HeroesTableUpdateCompanionBuilder,
          (HeroRow, BaseReferences<_$AppDatabase, $HeroesTable, HeroRow>),
          HeroRow,
          PrefetchHooks Function()
        > {
  $$HeroesTableTableManager(_$AppDatabase db, $HeroesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HeroesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HeroesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HeroesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<HeroForm> form = const Value.absent(),
                Value<HeroOrigin> origin = const Value.absent(),
                Value<String?> oath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> customOriginName = const Value.absent(),
                Value<String?> customOriginStory = const Value.absent(),
                Value<int> weeklyGoal = const Value.absent(),
                Value<int> waterGoalCups = const Value.absent(),
                Value<String?> equippedTitleId = const Value.absent(),
                Value<String?> equippedCosmeticId = const Value.absent(),
                Value<CharacterClass?> selectedClass = const Value.absent(),
                Value<String?> appearance = const Value.absent(),
              }) => HeroesCompanion(
                id: id,
                name: name,
                form: form,
                origin: origin,
                oath: oath,
                createdAt: createdAt,
                customOriginName: customOriginName,
                customOriginStory: customOriginStory,
                weeklyGoal: weeklyGoal,
                waterGoalCups: waterGoalCups,
                equippedTitleId: equippedTitleId,
                equippedCosmeticId: equippedCosmeticId,
                selectedClass: selectedClass,
                appearance: appearance,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required HeroForm form,
                required HeroOrigin origin,
                Value<String?> oath = const Value.absent(),
                required DateTime createdAt,
                Value<String?> customOriginName = const Value.absent(),
                Value<String?> customOriginStory = const Value.absent(),
                Value<int> weeklyGoal = const Value.absent(),
                Value<int> waterGoalCups = const Value.absent(),
                Value<String?> equippedTitleId = const Value.absent(),
                Value<String?> equippedCosmeticId = const Value.absent(),
                Value<CharacterClass?> selectedClass = const Value.absent(),
                Value<String?> appearance = const Value.absent(),
              }) => HeroesCompanion.insert(
                id: id,
                name: name,
                form: form,
                origin: origin,
                oath: oath,
                createdAt: createdAt,
                customOriginName: customOriginName,
                customOriginStory: customOriginStory,
                weeklyGoal: weeklyGoal,
                waterGoalCups: waterGoalCups,
                equippedTitleId: equippedTitleId,
                equippedCosmeticId: equippedCosmeticId,
                selectedClass: selectedClass,
                appearance: appearance,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HeroesTable, HeroRow>(table),
                  BaseReferences<_$AppDatabase, $HeroesTable, HeroRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HeroesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HeroesTable,
      HeroRow,
      $$HeroesTableFilterComposer,
      $$HeroesTableOrderingComposer,
      $$HeroesTableAnnotationComposer,
      $$HeroesTableCreateCompanionBuilder,
      $$HeroesTableUpdateCompanionBuilder,
      (HeroRow, BaseReferences<_$AppDatabase, $HeroesTable, HeroRow>),
      HeroRow,
      PrefetchHooks Function()
    >;
typedef $$DailyHealthLogsTableCreateCompanionBuilder =
    DailyHealthLogsCompanion Function({
      required String dateStr,
      Value<int> waterCups,
      Value<int> rewardedWaterCups,
      Value<bool> waterGoalBonusClaimed,
      Value<DietAdherence?> dietAdherence,
      Value<double?> lastSleepHours,
      Value<int> rowid,
    });
typedef $$DailyHealthLogsTableUpdateCompanionBuilder =
    DailyHealthLogsCompanion Function({
      Value<String> dateStr,
      Value<int> waterCups,
      Value<int> rewardedWaterCups,
      Value<bool> waterGoalBonusClaimed,
      Value<DietAdherence?> dietAdherence,
      Value<double?> lastSleepHours,
      Value<int> rowid,
    });

class $$DailyHealthLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyHealthLogsTable> {
  $$DailyHealthLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateStr => $composableBuilder(
    column: $table.dateStr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get waterCups => $composableBuilder(
    column: $table.waterCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardedWaterCups => $composableBuilder(
    column: $table.rewardedWaterCups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get waterGoalBonusClaimed => $composableBuilder(
    column: $table.waterGoalBonusClaimed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DietAdherence?, DietAdherence, String>
  get dietAdherence => $composableBuilder(
    column: $table.dietAdherence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get lastSleepHours => $composableBuilder(
    column: $table.lastSleepHours,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyHealthLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyHealthLogsTable> {
  $$DailyHealthLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateStr => $composableBuilder(
    column: $table.dateStr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get waterCups => $composableBuilder(
    column: $table.waterCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardedWaterCups => $composableBuilder(
    column: $table.rewardedWaterCups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get waterGoalBonusClaimed => $composableBuilder(
    column: $table.waterGoalBonusClaimed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietAdherence => $composableBuilder(
    column: $table.dietAdherence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastSleepHours => $composableBuilder(
    column: $table.lastSleepHours,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyHealthLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyHealthLogsTable> {
  $$DailyHealthLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateStr =>
      $composableBuilder(column: $table.dateStr, builder: (column) => column);

  GeneratedColumn<int> get waterCups =>
      $composableBuilder(column: $table.waterCups, builder: (column) => column);

  GeneratedColumn<int> get rewardedWaterCups => $composableBuilder(
    column: $table.rewardedWaterCups,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get waterGoalBonusClaimed => $composableBuilder(
    column: $table.waterGoalBonusClaimed,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DietAdherence?, String> get dietAdherence =>
      $composableBuilder(
        column: $table.dietAdherence,
        builder: (column) => column,
      );

  GeneratedColumn<double> get lastSleepHours => $composableBuilder(
    column: $table.lastSleepHours,
    builder: (column) => column,
  );
}

class $$DailyHealthLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyHealthLogsTable,
          DailyHealthRow,
          $$DailyHealthLogsTableFilterComposer,
          $$DailyHealthLogsTableOrderingComposer,
          $$DailyHealthLogsTableAnnotationComposer,
          $$DailyHealthLogsTableCreateCompanionBuilder,
          $$DailyHealthLogsTableUpdateCompanionBuilder,
          (
            DailyHealthRow,
            BaseReferences<
              _$AppDatabase,
              $DailyHealthLogsTable,
              DailyHealthRow
            >,
          ),
          DailyHealthRow,
          PrefetchHooks Function()
        > {
  $$DailyHealthLogsTableTableManager(
    _$AppDatabase db,
    $DailyHealthLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyHealthLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyHealthLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyHealthLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dateStr = const Value.absent(),
                Value<int> waterCups = const Value.absent(),
                Value<int> rewardedWaterCups = const Value.absent(),
                Value<bool> waterGoalBonusClaimed = const Value.absent(),
                Value<DietAdherence?> dietAdherence = const Value.absent(),
                Value<double?> lastSleepHours = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyHealthLogsCompanion(
                dateStr: dateStr,
                waterCups: waterCups,
                rewardedWaterCups: rewardedWaterCups,
                waterGoalBonusClaimed: waterGoalBonusClaimed,
                dietAdherence: dietAdherence,
                lastSleepHours: lastSleepHours,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dateStr,
                Value<int> waterCups = const Value.absent(),
                Value<int> rewardedWaterCups = const Value.absent(),
                Value<bool> waterGoalBonusClaimed = const Value.absent(),
                Value<DietAdherence?> dietAdherence = const Value.absent(),
                Value<double?> lastSleepHours = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyHealthLogsCompanion.insert(
                dateStr: dateStr,
                waterCups: waterCups,
                rewardedWaterCups: rewardedWaterCups,
                waterGoalBonusClaimed: waterGoalBonusClaimed,
                dietAdherence: dietAdherence,
                lastSleepHours: lastSleepHours,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyHealthLogsTable, DailyHealthRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyHealthLogsTable,
                    DailyHealthRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyHealthLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyHealthLogsTable,
      DailyHealthRow,
      $$DailyHealthLogsTableFilterComposer,
      $$DailyHealthLogsTableOrderingComposer,
      $$DailyHealthLogsTableAnnotationComposer,
      $$DailyHealthLogsTableCreateCompanionBuilder,
      $$DailyHealthLogsTableUpdateCompanionBuilder,
      (
        DailyHealthRow,
        BaseReferences<_$AppDatabase, $DailyHealthLogsTable, DailyHealthRow>,
      ),
      DailyHealthRow,
      PrefetchHooks Function()
    >;
typedef $$ArenaProgressTableCreateCompanionBuilder =
    ArenaProgressCompanion Function({
      required String opponentId,
      Value<int> victories,
      required DateTime lastDefeatedAt,
      Value<int> rowid,
    });
typedef $$ArenaProgressTableUpdateCompanionBuilder =
    ArenaProgressCompanion Function({
      Value<String> opponentId,
      Value<int> victories,
      Value<DateTime> lastDefeatedAt,
      Value<int> rowid,
    });

class $$ArenaProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ArenaProgressTable> {
  $$ArenaProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opponentId => $composableBuilder(
    column: $table.opponentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get victories => $composableBuilder(
    column: $table.victories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastDefeatedAt => $composableBuilder(
    column: $table.lastDefeatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArenaProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ArenaProgressTable> {
  $$ArenaProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opponentId => $composableBuilder(
    column: $table.opponentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get victories => $composableBuilder(
    column: $table.victories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastDefeatedAt => $composableBuilder(
    column: $table.lastDefeatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArenaProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArenaProgressTable> {
  $$ArenaProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opponentId => $composableBuilder(
    column: $table.opponentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get victories =>
      $composableBuilder(column: $table.victories, builder: (column) => column);

  GeneratedColumn<DateTime> get lastDefeatedAt => $composableBuilder(
    column: $table.lastDefeatedAt,
    builder: (column) => column,
  );
}

class $$ArenaProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArenaProgressTable,
          ArenaProgressRow,
          $$ArenaProgressTableFilterComposer,
          $$ArenaProgressTableOrderingComposer,
          $$ArenaProgressTableAnnotationComposer,
          $$ArenaProgressTableCreateCompanionBuilder,
          $$ArenaProgressTableUpdateCompanionBuilder,
          (
            ArenaProgressRow,
            BaseReferences<
              _$AppDatabase,
              $ArenaProgressTable,
              ArenaProgressRow
            >,
          ),
          ArenaProgressRow,
          PrefetchHooks Function()
        > {
  $$ArenaProgressTableTableManager(_$AppDatabase db, $ArenaProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArenaProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArenaProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArenaProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> opponentId = const Value.absent(),
                Value<int> victories = const Value.absent(),
                Value<DateTime> lastDefeatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArenaProgressCompanion(
                opponentId: opponentId,
                victories: victories,
                lastDefeatedAt: lastDefeatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String opponentId,
                Value<int> victories = const Value.absent(),
                required DateTime lastDefeatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ArenaProgressCompanion.insert(
                opponentId: opponentId,
                victories: victories,
                lastDefeatedAt: lastDefeatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ArenaProgressTable, ArenaProgressRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ArenaProgressTable,
                    ArenaProgressRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArenaProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArenaProgressTable,
      ArenaProgressRow,
      $$ArenaProgressTableFilterComposer,
      $$ArenaProgressTableOrderingComposer,
      $$ArenaProgressTableAnnotationComposer,
      $$ArenaProgressTableCreateCompanionBuilder,
      $$ArenaProgressTableUpdateCompanionBuilder,
      (
        ArenaProgressRow,
        BaseReferences<_$AppDatabase, $ArenaProgressTable, ArenaProgressRow>,
      ),
      ArenaProgressRow,
      PrefetchHooks Function()
    >;
typedef $$DailyArenaLogsTableCreateCompanionBuilder =
    DailyArenaLogsCompanion Function({
      required String dateStr,
      Value<int> entriesUsed,
      Value<int> rowid,
    });
typedef $$DailyArenaLogsTableUpdateCompanionBuilder =
    DailyArenaLogsCompanion Function({
      Value<String> dateStr,
      Value<int> entriesUsed,
      Value<int> rowid,
    });

class $$DailyArenaLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyArenaLogsTable> {
  $$DailyArenaLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateStr => $composableBuilder(
    column: $table.dateStr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entriesUsed => $composableBuilder(
    column: $table.entriesUsed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyArenaLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyArenaLogsTable> {
  $$DailyArenaLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateStr => $composableBuilder(
    column: $table.dateStr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entriesUsed => $composableBuilder(
    column: $table.entriesUsed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyArenaLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyArenaLogsTable> {
  $$DailyArenaLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateStr =>
      $composableBuilder(column: $table.dateStr, builder: (column) => column);

  GeneratedColumn<int> get entriesUsed => $composableBuilder(
    column: $table.entriesUsed,
    builder: (column) => column,
  );
}

class $$DailyArenaLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyArenaLogsTable,
          DailyArenaLogRow,
          $$DailyArenaLogsTableFilterComposer,
          $$DailyArenaLogsTableOrderingComposer,
          $$DailyArenaLogsTableAnnotationComposer,
          $$DailyArenaLogsTableCreateCompanionBuilder,
          $$DailyArenaLogsTableUpdateCompanionBuilder,
          (
            DailyArenaLogRow,
            BaseReferences<
              _$AppDatabase,
              $DailyArenaLogsTable,
              DailyArenaLogRow
            >,
          ),
          DailyArenaLogRow,
          PrefetchHooks Function()
        > {
  $$DailyArenaLogsTableTableManager(
    _$AppDatabase db,
    $DailyArenaLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyArenaLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyArenaLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyArenaLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dateStr = const Value.absent(),
                Value<int> entriesUsed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyArenaLogsCompanion(
                dateStr: dateStr,
                entriesUsed: entriesUsed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dateStr,
                Value<int> entriesUsed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyArenaLogsCompanion.insert(
                dateStr: dateStr,
                entriesUsed: entriesUsed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyArenaLogsTable, DailyArenaLogRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyArenaLogsTable,
                    DailyArenaLogRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyArenaLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyArenaLogsTable,
      DailyArenaLogRow,
      $$DailyArenaLogsTableFilterComposer,
      $$DailyArenaLogsTableOrderingComposer,
      $$DailyArenaLogsTableAnnotationComposer,
      $$DailyArenaLogsTableCreateCompanionBuilder,
      $$DailyArenaLogsTableUpdateCompanionBuilder,
      (
        DailyArenaLogRow,
        BaseReferences<_$AppDatabase, $DailyArenaLogsTable, DailyArenaLogRow>,
      ),
      DailyArenaLogRow,
      PrefetchHooks Function()
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String id,
      required String title,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
      Value<String?> routineId,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
      Value<String?> routineId,
      Value<int> rowid,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'workout_sessions__id__workout_sets__session_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager(
      $_db,
      $_db.workoutSets,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get routineId =>
      $composableBuilder(column: $table.routineId, builder: (column) => column);

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({bool workoutSetsRefs})
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> routineId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                title: title,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
                routineId: routineId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> routineId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                title: title,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
                routineId: routineId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutSetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (workoutSetsRefs) db.workoutSets],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetsRefs)
                    await $_getPrefetchedDataByColumns<
                      WorkoutSession,
                      $WorkoutSessionsTable,
                      WorkoutSet,
                      $WorkoutSetsTable
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutSessionsTableReferences
                          ._workoutSetsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutSetsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'session_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({bool workoutSetsRefs})
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      required String id,
      required String sessionId,
      required String exerciseId,
      required int setOrder,
      required double weightKg,
      required int reps,
      Value<int> durationSeconds,
      Value<double> rpe,
      Value<bool> isCompleted,
      Value<bool> isPersonalRecord,
      Value<int> rowid,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> exerciseId,
      Value<int> setOrder,
      Value<double> weightKg,
      Value<int> reps,
      Value<int> durationSeconds,
      Value<double> rpe,
      Value<bool> isCompleted,
      Value<bool> isPersonalRecord,
      Value<int> rowid,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('workout_sets__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('workout_sets__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setOrder => $composableBuilder(
    column: $table.setOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPersonalRecord => $composableBuilder(
    column: $table.isPersonalRecord,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setOrder => $composableBuilder(
    column: $table.setOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rpe => $composableBuilder(
    column: $table.rpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPersonalRecord => $composableBuilder(
    column: $table.isPersonalRecord,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setOrder =>
      $composableBuilder(column: $table.setOrder, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPersonalRecord => $composableBuilder(
    column: $table.isPersonalRecord,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$WorkoutSetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({bool sessionId, bool exerciseId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> setOrder = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<double> rpe = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isPersonalRecord = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                setOrder: setOrder,
                weightKg: weightKg,
                reps: reps,
                durationSeconds: durationSeconds,
                rpe: rpe,
                isCompleted: isCompleted,
                isPersonalRecord: isPersonalRecord,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String exerciseId,
                required int setOrder,
                required double weightKg,
                required int reps,
                Value<int> durationSeconds = const Value.absent(),
                Value<double> rpe = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isPersonalRecord = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                sessionId: sessionId,
                exerciseId: exerciseId,
                setOrder: setOrder,
                weightKg: weightKg,
                reps: reps,
                durationSeconds: durationSeconds,
                rpe: rpe,
                isCompleted: isCompleted,
                isPersonalRecord: isPersonalRecord,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetsTable, WorkoutSet>(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$WorkoutSetsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$WorkoutSetsTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$WorkoutSetsTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$WorkoutSetsTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$WorkoutSetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({bool sessionId, bool exerciseId})
    >;
typedef $$PersonalRecordsTableCreateCompanionBuilder =
    PersonalRecordsCompanion Function({
      required String exerciseId,
      required double maxWeightKg,
      required double estimatedOneRepMax,
      required int repsAtMaxWeight,
      required DateTime achievedAt,
      Value<int> rowid,
    });
typedef $$PersonalRecordsTableUpdateCompanionBuilder =
    PersonalRecordsCompanion Function({
      Value<String> exerciseId,
      Value<double> maxWeightKg,
      Value<double> estimatedOneRepMax,
      Value<int> repsAtMaxWeight,
      Value<DateTime> achievedAt,
      Value<int> rowid,
    });

final class $$PersonalRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $PersonalRecordsTable, PersonalRecord> {
  $$PersonalRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('personal_records__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PersonalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get maxWeightKg => $composableBuilder(
    column: $table.maxWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get estimatedOneRepMax => $composableBuilder(
    column: $table.estimatedOneRepMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repsAtMaxWeight => $composableBuilder(
    column: $table.repsAtMaxWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get maxWeightKg => $composableBuilder(
    column: $table.maxWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get estimatedOneRepMax => $composableBuilder(
    column: $table.estimatedOneRepMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repsAtMaxWeight => $composableBuilder(
    column: $table.repsAtMaxWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalRecordsTable> {
  $$PersonalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get maxWeightKg => $composableBuilder(
    column: $table.maxWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get estimatedOneRepMax => $composableBuilder(
    column: $table.estimatedOneRepMax,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repsAtMaxWeight => $composableBuilder(
    column: $table.repsAtMaxWeight,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonalRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalRecordsTable,
          PersonalRecord,
          $$PersonalRecordsTableFilterComposer,
          $$PersonalRecordsTableOrderingComposer,
          $$PersonalRecordsTableAnnotationComposer,
          $$PersonalRecordsTableCreateCompanionBuilder,
          $$PersonalRecordsTableUpdateCompanionBuilder,
          (PersonalRecord, $$PersonalRecordsTableReferences),
          PersonalRecord,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$PersonalRecordsTableTableManager(
    _$AppDatabase db,
    $PersonalRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> exerciseId = const Value.absent(),
                Value<double> maxWeightKg = const Value.absent(),
                Value<double> estimatedOneRepMax = const Value.absent(),
                Value<int> repsAtMaxWeight = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordsCompanion(
                exerciseId: exerciseId,
                maxWeightKg: maxWeightKg,
                estimatedOneRepMax: estimatedOneRepMax,
                repsAtMaxWeight: repsAtMaxWeight,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String exerciseId,
                required double maxWeightKg,
                required double estimatedOneRepMax,
                required int repsAtMaxWeight,
                required DateTime achievedAt,
                Value<int> rowid = const Value.absent(),
              }) => PersonalRecordsCompanion.insert(
                exerciseId: exerciseId,
                maxWeightKg: maxWeightKg,
                estimatedOneRepMax: estimatedOneRepMax,
                repsAtMaxWeight: repsAtMaxWeight,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PersonalRecordsTable, PersonalRecord>(table),
                  $$PersonalRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (exerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exerciseId,
                        referencedTable: $$PersonalRecordsTableReferences
                            ._exerciseIdTable(db),
                        referencedColumn: $$PersonalRecordsTableReferences
                            ._exerciseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PersonalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalRecordsTable,
      PersonalRecord,
      $$PersonalRecordsTableFilterComposer,
      $$PersonalRecordsTableOrderingComposer,
      $$PersonalRecordsTableAnnotationComposer,
      $$PersonalRecordsTableCreateCompanionBuilder,
      $$PersonalRecordsTableUpdateCompanionBuilder,
      (PersonalRecord, $$PersonalRecordsTableReferences),
      PersonalRecord,
      PrefetchHooks Function({bool exerciseId})
    >;
typedef $$ActivitiesTableCreateCompanionBuilder = ActivitiesCompanion Function({
  required String id,
  required String type,
  required Attribute attribute,
  required double durationMinutes,
  Value<double> intensity,
  required DateTime timestamp,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$ActivitiesTableUpdateCompanionBuilder = ActivitiesCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<Attribute> attribute,
  Value<double> durationMinutes,
  Value<double> intensity,
  Value<DateTime> timestamp,
  Value<String?> notes,
  Value<int> rowid,
});

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Attribute, Attribute, String> get attribute =>
      $composableBuilder(
        column: $table.attribute,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attribute => $composableBuilder(
    column: $table.attribute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Attribute, String> get attribute =>
      $composableBuilder(column: $table.attribute, builder: (column) => column);

  GeneratedColumn<double> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>),
          Activity,
          PrefetchHooks Function()
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<Attribute> attribute = const Value.absent(),
                Value<double> durationMinutes = const Value.absent(),
                Value<double> intensity = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                type: type,
                attribute: attribute,
                durationMinutes: durationMinutes,
                intensity: intensity,
                timestamp: timestamp,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required Attribute attribute,
                required double durationMinutes,
                Value<double> intensity = const Value.absent(),
                required DateTime timestamp,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                id: id,
                type: type,
                attribute: attribute,
                durationMinutes: durationMinutes,
                intensity: intensity,
                timestamp: timestamp,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivitiesTable, Activity>(table),
                  BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>),
      Activity,
      PrefetchHooks Function()
    >;
typedef $$XpLedgerTableCreateCompanionBuilder = XpLedgerCompanion Function({
  required String id,
  required Attribute attribute,
  required double amount,
  required XpSource source,
  required DateTime timestamp,
  Value<String?> description,
  Value<int> rowid,
});
typedef $$XpLedgerTableUpdateCompanionBuilder = XpLedgerCompanion Function({
  Value<String> id,
  Value<Attribute> attribute,
  Value<double> amount,
  Value<XpSource> source,
  Value<DateTime> timestamp,
  Value<String?> description,
  Value<int> rowid,
});

class $$XpLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $XpLedgerTable> {
  $$XpLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Attribute, Attribute, String> get attribute =>
      $composableBuilder(
        column: $table.attribute,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<XpSource, XpSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$XpLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $XpLedgerTable> {
  $$XpLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attribute => $composableBuilder(
    column: $table.attribute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$XpLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpLedgerTable> {
  $$XpLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Attribute, String> get attribute =>
      $composableBuilder(column: $table.attribute, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<XpSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$XpLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $XpLedgerTable,
          XpLedgerData,
          $$XpLedgerTableFilterComposer,
          $$XpLedgerTableOrderingComposer,
          $$XpLedgerTableAnnotationComposer,
          $$XpLedgerTableCreateCompanionBuilder,
          $$XpLedgerTableUpdateCompanionBuilder,
          (
            XpLedgerData,
            BaseReferences<_$AppDatabase, $XpLedgerTable, XpLedgerData>,
          ),
          XpLedgerData,
          PrefetchHooks Function()
        > {
  $$XpLedgerTableTableManager(_$AppDatabase db, $XpLedgerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<Attribute> attribute = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<XpSource> source = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => XpLedgerCompanion(
                id: id,
                attribute: attribute,
                amount: amount,
                source: source,
                timestamp: timestamp,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required Attribute attribute,
                required double amount,
                required XpSource source,
                required DateTime timestamp,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => XpLedgerCompanion.insert(
                id: id,
                attribute: attribute,
                amount: amount,
                source: source,
                timestamp: timestamp,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$XpLedgerTable, XpLedgerData>(table),
                  BaseReferences<_$AppDatabase, $XpLedgerTable, XpLedgerData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$XpLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $XpLedgerTable,
      XpLedgerData,
      $$XpLedgerTableFilterComposer,
      $$XpLedgerTableOrderingComposer,
      $$XpLedgerTableAnnotationComposer,
      $$XpLedgerTableCreateCompanionBuilder,
      $$XpLedgerTableUpdateCompanionBuilder,
      (
        XpLedgerData,
        BaseReferences<_$AppDatabase, $XpLedgerTable, XpLedgerData>,
      ),
      XpLedgerData,
      PrefetchHooks Function()
    >;
typedef $$DailyQuestsTableTableCreateCompanionBuilder =
    DailyQuestsTableCompanion Function({
      required String id,
      required String dateStr,
      required String title,
      required String description,
      required Attribute targetAttribute,
      required double targetValue,
      required double currentValue,
      required String unit,
      required double bonusXp,
      Value<bool> grantsInspiration,
      Value<bool> isCompleted,
      Value<int> rowid,
    });
typedef $$DailyQuestsTableTableUpdateCompanionBuilder =
    DailyQuestsTableCompanion Function({
      Value<String> id,
      Value<String> dateStr,
      Value<String> title,
      Value<String> description,
      Value<Attribute> targetAttribute,
      Value<double> targetValue,
      Value<double> currentValue,
      Value<String> unit,
      Value<double> bonusXp,
      Value<bool> grantsInspiration,
      Value<bool> isCompleted,
      Value<int> rowid,
    });

class $$DailyQuestsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DailyQuestsTableTable> {
  $$DailyQuestsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateStr => $composableBuilder(
    column: $table.dateStr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Attribute, Attribute, String>
  get targetAttribute => $composableBuilder(
    column: $table.targetAttribute,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bonusXp => $composableBuilder(
    column: $table.bonusXp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get grantsInspiration => $composableBuilder(
    column: $table.grantsInspiration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyQuestsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyQuestsTableTable> {
  $$DailyQuestsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateStr => $composableBuilder(
    column: $table.dateStr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetAttribute => $composableBuilder(
    column: $table.targetAttribute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bonusXp => $composableBuilder(
    column: $table.bonusXp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get grantsInspiration => $composableBuilder(
    column: $table.grantsInspiration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyQuestsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyQuestsTableTable> {
  $$DailyQuestsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateStr =>
      $composableBuilder(column: $table.dateStr, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Attribute, String> get targetAttribute =>
      $composableBuilder(
        column: $table.targetAttribute,
        builder: (column) => column,
      );

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentValue => $composableBuilder(
    column: $table.currentValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get bonusXp =>
      $composableBuilder(column: $table.bonusXp, builder: (column) => column);

  GeneratedColumn<bool> get grantsInspiration => $composableBuilder(
    column: $table.grantsInspiration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );
}

class $$DailyQuestsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyQuestsTableTable,
          DailyQuestsTableData,
          $$DailyQuestsTableTableFilterComposer,
          $$DailyQuestsTableTableOrderingComposer,
          $$DailyQuestsTableTableAnnotationComposer,
          $$DailyQuestsTableTableCreateCompanionBuilder,
          $$DailyQuestsTableTableUpdateCompanionBuilder,
          (
            DailyQuestsTableData,
            BaseReferences<
              _$AppDatabase,
              $DailyQuestsTableTable,
              DailyQuestsTableData
            >,
          ),
          DailyQuestsTableData,
          PrefetchHooks Function()
        > {
  $$DailyQuestsTableTableTableManager(
    _$AppDatabase db,
    $DailyQuestsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyQuestsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyQuestsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyQuestsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> dateStr = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<Attribute> targetAttribute = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<double> currentValue = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> bonusXp = const Value.absent(),
                Value<bool> grantsInspiration = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestsTableCompanion(
                id: id,
                dateStr: dateStr,
                title: title,
                description: description,
                targetAttribute: targetAttribute,
                targetValue: targetValue,
                currentValue: currentValue,
                unit: unit,
                bonusXp: bonusXp,
                grantsInspiration: grantsInspiration,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String dateStr,
                required String title,
                required String description,
                required Attribute targetAttribute,
                required double targetValue,
                required double currentValue,
                required String unit,
                required double bonusXp,
                Value<bool> grantsInspiration = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestsTableCompanion.insert(
                id: id,
                dateStr: dateStr,
                title: title,
                description: description,
                targetAttribute: targetAttribute,
                targetValue: targetValue,
                currentValue: currentValue,
                unit: unit,
                bonusXp: bonusXp,
                grantsInspiration: grantsInspiration,
                isCompleted: isCompleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyQuestsTableTable, DailyQuestsTableData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $DailyQuestsTableTable,
                    DailyQuestsTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyQuestsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyQuestsTableTable,
      DailyQuestsTableData,
      $$DailyQuestsTableTableFilterComposer,
      $$DailyQuestsTableTableOrderingComposer,
      $$DailyQuestsTableTableAnnotationComposer,
      $$DailyQuestsTableTableCreateCompanionBuilder,
      $$DailyQuestsTableTableUpdateCompanionBuilder,
      (
        DailyQuestsTableData,
        BaseReferences<
          _$AppDatabase,
          $DailyQuestsTableTable,
          DailyQuestsTableData
        >,
      ),
      DailyQuestsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$RoutineExercisesTableTableManager get routineExercises =>
      $$RoutineExercisesTableTableManager(_db, _db.routineExercises);
  $$HeroesTableTableManager get heroes =>
      $$HeroesTableTableManager(_db, _db.heroes);
  $$DailyHealthLogsTableTableManager get dailyHealthLogs =>
      $$DailyHealthLogsTableTableManager(_db, _db.dailyHealthLogs);
  $$ArenaProgressTableTableManager get arenaProgress =>
      $$ArenaProgressTableTableManager(_db, _db.arenaProgress);
  $$DailyArenaLogsTableTableManager get dailyArenaLogs =>
      $$DailyArenaLogsTableTableManager(_db, _db.dailyArenaLogs);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$PersonalRecordsTableTableManager get personalRecords =>
      $$PersonalRecordsTableTableManager(_db, _db.personalRecords);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$XpLedgerTableTableManager get xpLedger =>
      $$XpLedgerTableTableManager(_db, _db.xpLedger);
  $$DailyQuestsTableTableTableManager get dailyQuestsTable =>
      $$DailyQuestsTableTableTableManager(_db, _db.dailyQuestsTable);
}

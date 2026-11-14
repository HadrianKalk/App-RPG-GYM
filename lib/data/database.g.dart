// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    form,
    origin,
    oath,
    createdAt,
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
}

class HeroRow extends DataClass implements Insertable<HeroRow> {
  final int id;
  final String name;
  final HeroForm form;
  final HeroOrigin origin;
  final String? oath;
  final DateTime createdAt;
  const HeroRow({
    required this.id,
    required this.name,
    required this.form,
    required this.origin,
    this.oath,
    required this.createdAt,
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
    };
  }

  HeroRow copyWith({
    int? id,
    String? name,
    HeroForm? form,
    HeroOrigin? origin,
    Value<String?> oath = const Value.absent(),
    DateTime? createdAt,
  }) => HeroRow(
    id: id ?? this.id,
    name: name ?? this.name,
    form: form ?? this.form,
    origin: origin ?? this.origin,
    oath: oath.present ? oath.value : this.oath,
    createdAt: createdAt ?? this.createdAt,
  );
  HeroRow copyWithCompanion(HeroesCompanion data) {
    return HeroRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      form: data.form.present ? data.form.value : this.form,
      origin: data.origin.present ? data.origin.value : this.origin,
      oath: data.oath.present ? data.oath.value : this.oath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
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
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, form, origin, oath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeroRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.form == this.form &&
          other.origin == this.origin &&
          other.oath == this.oath &&
          other.createdAt == this.createdAt);
}

class HeroesCompanion extends UpdateCompanion<HeroRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<HeroForm> form;
  final Value<HeroOrigin> origin;
  final Value<String?> oath;
  final Value<DateTime> createdAt;
  const HeroesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.form = const Value.absent(),
    this.origin = const Value.absent(),
    this.oath = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HeroesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required HeroForm form,
    required HeroOrigin origin,
    this.oath = const Value.absent(),
    required DateTime createdAt,
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (form != null) 'form': form,
      if (origin != null) 'origin': origin,
      if (oath != null) 'oath': oath,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HeroesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<HeroForm>? form,
    Value<HeroOrigin>? origin,
    Value<String?>? oath,
    Value<DateTime>? createdAt,
  }) {
    return HeroesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      form: form ?? this.form,
      origin: origin ?? this.origin,
      oath: oath ?? this.oath,
      createdAt: createdAt ?? this.createdAt,
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
          ..write('createdAt: $createdAt')
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    startedAt,
    completedAt,
    notes,
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
  const WorkoutSession({
    required this.id,
    required this.title,
    required this.startedAt,
    this.completedAt,
    this.notes,
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
    };
  }

  WorkoutSession copyWith({
    String? id,
    String? title,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => WorkoutSession(
    id: id ?? this.id,
    title: title ?? this.title,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    notes: notes.present ? notes.value : this.notes,
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, startedAt, completedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.title == this.title &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<String> title;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String?> notes;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required String title,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
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
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
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
  late final $HeroesTable heroes = $HeroesTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
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
    heroes,
    exercises,
    workoutSessions,
    workoutSets,
    personalRecords,
    activities,
    xpLedger,
    dailyQuestsTable,
  ];
}

typedef $$HeroesTableCreateCompanionBuilder = HeroesCompanion Function({
  Value<int> id,
  required String name,
  required HeroForm form,
  required HeroOrigin origin,
  Value<String?> oath,
  required DateTime createdAt,
});
typedef $$HeroesTableUpdateCompanionBuilder = HeroesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<HeroForm> form,
  Value<HeroOrigin> origin,
  Value<String?> oath,
  Value<DateTime> createdAt,
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
              }) => HeroesCompanion(
                id: id,
                name: name,
                form: form,
                origin: origin,
                oath: oath,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required HeroForm form,
                required HeroOrigin origin,
                Value<String?> oath = const Value.absent(),
                required DateTime createdAt,
              }) => HeroesCompanion.insert(
                id: id,
                name: name,
                form: form,
                origin: origin,
                oath: oath,
                createdAt: createdAt,
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
              ({workoutSetsRefs = false, personalRecordsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                    if (personalRecordsRefs) db.personalRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
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
      PrefetchHooks Function({bool workoutSetsRefs, bool personalRecordsRefs})
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String id,
      required String title,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
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
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                title: title,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                title: title,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
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
  $$HeroesTableTableManager get heroes =>
      $$HeroesTableTableManager(_db, _db.heroes);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
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

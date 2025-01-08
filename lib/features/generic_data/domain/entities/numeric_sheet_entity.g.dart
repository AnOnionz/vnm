// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'numeric_sheet_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNumericSheetEntityCollection on Isar {
  IsarCollection<NumericSheetEntity> get numericSheetEntitys =>
      this.collection();
}

const NumericSheetEntitySchema = CollectionSchema(
  name: r'NumericSheetEntity',
  id: -9020793615922518385,
  properties: {
    r'attendanceId': PropertySchema(
      id: 0,
      name: r'attendanceId',
      type: IsarType.long,
    ),
    r'dataTimestamp': PropertySchema(
      id: 1,
      name: r'dataTimestamp',
      type: IsarType.dateTime,
    ),
    r'dataUuid': PropertySchema(
      id: 2,
      name: r'dataUuid',
      type: IsarType.string,
    ),
    r'featureId': PropertySchema(
      id: 3,
      name: r'featureId',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 4,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.long,
    ),
    r'keys': PropertySchema(
      id: 6,
      name: r'keys',
      type: IsarType.longList,
    ),
    r'status': PropertySchema(
      id: 7,
      name: r'status',
      type: IsarType.string,
      enumMap: _NumericSheetEntitystatusEnumValueMap,
    ),
    r'values': PropertySchema(
      id: 8,
      name: r'values',
      type: IsarType.objectList,
      target: r'NumericValueEntity',
    )
  },
  estimateSize: _numericSheetEntityEstimateSize,
  serialize: _numericSheetEntitySerialize,
  deserialize: _numericSheetEntityDeserialize,
  deserializeProp: _numericSheetEntityDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'keys': IndexSchema(
      id: 8738211483898358843,
      name: r'keys',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'keys',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'NumericValueEntity': NumericValueEntitySchema},
  getId: _numericSheetEntityGetId,
  getLinks: _numericSheetEntityGetLinks,
  attach: _numericSheetEntityAttach,
  version: '3.1.0+1',
);

int _numericSheetEntityEstimateSize(
  NumericSheetEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dataUuid;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.keys.length * 8;
  bytesCount += 3 + object.status.name.length * 3;
  bytesCount += 3 + object.values.length * 3;
  {
    final offsets = allOffsets[NumericValueEntity]!;
    for (var i = 0; i < object.values.length; i++) {
      final value = object.values[i];
      bytesCount +=
          NumericValueEntitySchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _numericSheetEntitySerialize(
  NumericSheetEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attendanceId);
  writer.writeDateTime(offsets[1], object.dataTimestamp);
  writer.writeString(offsets[2], object.dataUuid);
  writer.writeLong(offsets[3], object.featureId);
  writer.writeLong(offsets[4], object.hashCode);
  writer.writeLong(offsets[5], object.id);
  writer.writeLongList(offsets[6], object.keys);
  writer.writeString(offsets[7], object.status.name);
  writer.writeObjectList<NumericValueEntity>(
    offsets[8],
    allOffsets,
    NumericValueEntitySchema.serialize,
    object.values,
  );
}

NumericSheetEntity _numericSheetEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NumericSheetEntity(
    attendanceId: reader.readLongOrNull(offsets[0]),
    dataTimestamp: reader.readDateTimeOrNull(offsets[1]),
    dataUuid: reader.readStringOrNull(offsets[2]),
    featureId: reader.readLongOrNull(offsets[3]),
    id: reader.readLongOrNull(offsets[5]),
    status: _NumericSheetEntitystatusValueEnumMap[
            reader.readStringOrNull(offsets[7])] ??
        SyncStatus.isNoSynced,
    values: reader.readObjectList<NumericValueEntity>(
          offsets[8],
          NumericValueEntitySchema.deserialize,
          allOffsets,
          NumericValueEntity(),
        ) ??
        [],
  );
  return object;
}

P _numericSheetEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongList(offset) ?? []) as P;
    case 7:
      return (_NumericSheetEntitystatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncStatus.isNoSynced) as P;
    case 8:
      return (reader.readObjectList<NumericValueEntity>(
            offset,
            NumericValueEntitySchema.deserialize,
            allOffsets,
            NumericValueEntity(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _NumericSheetEntitystatusEnumValueMap = {
  r'synced': r'synced',
  r'isNoSynced': r'isNoSynced',
  r'isDeleted': r'isDeleted',
};
const _NumericSheetEntitystatusValueEnumMap = {
  r'synced': SyncStatus.synced,
  r'isNoSynced': SyncStatus.isNoSynced,
  r'isDeleted': SyncStatus.isDeleted,
};

Id _numericSheetEntityGetId(NumericSheetEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _numericSheetEntityGetLinks(
    NumericSheetEntity object) {
  return [];
}

void _numericSheetEntityAttach(
    IsarCollection<dynamic> col, Id id, NumericSheetEntity object) {}

extension NumericSheetEntityQueryWhereSort
    on QueryBuilder<NumericSheetEntity, NumericSheetEntity, QWhere> {
  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhere>
      anyKeysElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'keys'),
      );
    });
  }
}

extension NumericSheetEntityQueryWhere
    on QueryBuilder<NumericSheetEntity, NumericSheetEntity, QWhereClause> {
  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      keysElementEqualTo(int keysElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'keys',
        value: [keysElement],
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      keysElementNotEqualTo(int keysElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keys',
              lower: [],
              upper: [keysElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keys',
              lower: [keysElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keys',
              lower: [keysElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'keys',
              lower: [],
              upper: [keysElement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      keysElementGreaterThan(
    int keysElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'keys',
        lower: [keysElement],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      keysElementLessThan(
    int keysElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'keys',
        lower: [],
        upper: [keysElement],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterWhereClause>
      keysElementBetween(
    int lowerKeysElement,
    int upperKeysElement, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'keys',
        lower: [lowerKeysElement],
        includeLower: includeLower,
        upper: [upperKeysElement],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NumericSheetEntityQueryFilter
    on QueryBuilder<NumericSheetEntity, NumericSheetEntity, QFilterCondition> {
  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      attendanceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'attendanceId',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      attendanceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'attendanceId',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      attendanceIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attendanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      attendanceIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attendanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      attendanceIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attendanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      attendanceIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attendanceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataTimestamp',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataTimestamp',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataTimestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataTimestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataTimestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataTimestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataUuid',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataUuid',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataUuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dataUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dataUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      dataUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      featureIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'featureId',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      featureIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'featureId',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      featureIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      featureIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'featureId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      featureIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'featureId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      featureIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'featureId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      idEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      idLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keys',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'keys',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'keys',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'keys',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keys',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keys',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keys',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keys',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keys',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      keysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keys',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusEqualTo(
    SyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusGreaterThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusLessThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      valuesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      valuesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      valuesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      valuesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      valuesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      valuesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'values',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension NumericSheetEntityQueryObject
    on QueryBuilder<NumericSheetEntity, NumericSheetEntity, QFilterCondition> {
  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterFilterCondition>
      valuesElement(FilterQuery<NumericValueEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'values');
    });
  }
}

extension NumericSheetEntityQueryLinks
    on QueryBuilder<NumericSheetEntity, NumericSheetEntity, QFilterCondition> {}

extension NumericSheetEntityQuerySortBy
    on QueryBuilder<NumericSheetEntity, NumericSheetEntity, QSortBy> {
  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByAttendanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceId', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByAttendanceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceId', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByDataTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataTimestamp', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByDataTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataTimestamp', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByDataUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataUuid', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByDataUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataUuid', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByFeatureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureId', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByFeatureIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureId', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension NumericSheetEntityQuerySortThenBy
    on QueryBuilder<NumericSheetEntity, NumericSheetEntity, QSortThenBy> {
  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByAttendanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceId', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByAttendanceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceId', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByDataTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataTimestamp', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByDataTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataTimestamp', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByDataUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataUuid', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByDataUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataUuid', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByFeatureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureId', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByFeatureIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureId', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension NumericSheetEntityQueryWhereDistinct
    on QueryBuilder<NumericSheetEntity, NumericSheetEntity, QDistinct> {
  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QDistinct>
      distinctByAttendanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attendanceId');
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QDistinct>
      distinctByDataTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataTimestamp');
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QDistinct>
      distinctByDataUuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QDistinct>
      distinctByFeatureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'featureId');
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QDistinct>
      distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QDistinct>
      distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QDistinct>
      distinctByKeys() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keys');
    });
  }

  QueryBuilder<NumericSheetEntity, NumericSheetEntity, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension NumericSheetEntityQueryProperty
    on QueryBuilder<NumericSheetEntity, NumericSheetEntity, QQueryProperty> {
  QueryBuilder<NumericSheetEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<NumericSheetEntity, int?, QQueryOperations>
      attendanceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attendanceId');
    });
  }

  QueryBuilder<NumericSheetEntity, DateTime?, QQueryOperations>
      dataTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataTimestamp');
    });
  }

  QueryBuilder<NumericSheetEntity, String?, QQueryOperations>
      dataUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataUuid');
    });
  }

  QueryBuilder<NumericSheetEntity, int?, QQueryOperations> featureIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'featureId');
    });
  }

  QueryBuilder<NumericSheetEntity, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<NumericSheetEntity, int?, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NumericSheetEntity, List<int>, QQueryOperations> keysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keys');
    });
  }

  QueryBuilder<NumericSheetEntity, SyncStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<NumericSheetEntity, List<NumericValueEntity>, QQueryOperations>
      valuesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'values');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const NumericValueEntitySchema = Schema(
  name: r'NumericValueEntity',
  id: 5646220316202333050,
  properties: {
    r'featureNumericAttributeId': PropertySchema(
      id: 0,
      name: r'featureNumericAttributeId',
      type: IsarType.long,
    ),
    r'featureNumericId': PropertySchema(
      id: 1,
      name: r'featureNumericId',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 2,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.long,
    ),
    r'value': PropertySchema(
      id: 4,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _numericValueEntityEstimateSize,
  serialize: _numericValueEntitySerialize,
  deserialize: _numericValueEntityDeserialize,
  deserializeProp: _numericValueEntityDeserializeProp,
);

int _numericValueEntityEstimateSize(
  NumericValueEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.value;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _numericValueEntitySerialize(
  NumericValueEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.featureNumericAttributeId);
  writer.writeLong(offsets[1], object.featureNumericId);
  writer.writeLong(offsets[2], object.hashCode);
  writer.writeLong(offsets[3], object.id);
  writer.writeString(offsets[4], object.value);
}

NumericValueEntity _numericValueEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NumericValueEntity(
    featureNumericAttributeId: reader.readLongOrNull(offsets[0]),
    featureNumericId: reader.readLongOrNull(offsets[1]),
    id: reader.readLongOrNull(offsets[3]),
    value: reader.readStringOrNull(offsets[4]),
  );
  return object;
}

P _numericValueEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension NumericValueEntityQueryFilter
    on QueryBuilder<NumericValueEntity, NumericValueEntity, QFilterCondition> {
  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericAttributeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'featureNumericAttributeId',
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericAttributeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'featureNumericAttributeId',
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericAttributeIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureNumericAttributeId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericAttributeIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'featureNumericAttributeId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericAttributeIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'featureNumericAttributeId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericAttributeIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'featureNumericAttributeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'featureNumericId',
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'featureNumericId',
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureNumericId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'featureNumericId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'featureNumericId',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      featureNumericIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'featureNumericId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      idEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      idLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<NumericValueEntity, NumericValueEntity, QAfterFilterCondition>
      valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension NumericValueEntityQueryObject
    on QueryBuilder<NumericValueEntity, NumericValueEntity, QFilterCondition> {}

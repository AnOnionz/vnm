// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oos_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOOSEntityCollection on Isar {
  IsarCollection<OOSEntity> get oOSEntitys => this.collection();
}

const OOSEntitySchema = CollectionSchema(
  name: r'OOSEntity',
  id: 3341881355830794702,
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
    r'featureOosZoneId': PropertySchema(
      id: 4,
      name: r'featureOosZoneId',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 5,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 6,
      name: r'id',
      type: IsarType.long,
    ),
    r'keys': PropertySchema(
      id: 7,
      name: r'keys',
      type: IsarType.longList,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
      enumMap: _OOSEntitystatusEnumValueMap,
    ),
    r'values': PropertySchema(
      id: 9,
      name: r'values',
      type: IsarType.objectList,
      target: r'OOSStatusValueEntity',
    )
  },
  estimateSize: _oOSEntityEstimateSize,
  serialize: _oOSEntitySerialize,
  deserialize: _oOSEntityDeserialize,
  deserializeProp: _oOSEntityDeserializeProp,
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
  embeddedSchemas: {r'OOSStatusValueEntity': OOSStatusValueEntitySchema},
  getId: _oOSEntityGetId,
  getLinks: _oOSEntityGetLinks,
  attach: _oOSEntityAttach,
  version: '3.1.0+1',
);

int _oOSEntityEstimateSize(
  OOSEntity object,
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
    final offsets = allOffsets[OOSStatusValueEntity]!;
    for (var i = 0; i < object.values.length; i++) {
      final value = object.values[i];
      bytesCount +=
          OOSStatusValueEntitySchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _oOSEntitySerialize(
  OOSEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attendanceId);
  writer.writeDateTime(offsets[1], object.dataTimestamp);
  writer.writeString(offsets[2], object.dataUuid);
  writer.writeLong(offsets[3], object.featureId);
  writer.writeLong(offsets[4], object.featureOosZoneId);
  writer.writeLong(offsets[5], object.hashCode);
  writer.writeLong(offsets[6], object.id);
  writer.writeLongList(offsets[7], object.keys);
  writer.writeString(offsets[8], object.status.name);
  writer.writeObjectList<OOSStatusValueEntity>(
    offsets[9],
    allOffsets,
    OOSStatusValueEntitySchema.serialize,
    object.values,
  );
}

OOSEntity _oOSEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OOSEntity(
    attendanceId: reader.readLongOrNull(offsets[0]),
    dataTimestamp: reader.readDateTimeOrNull(offsets[1]),
    dataUuid: reader.readStringOrNull(offsets[2]),
    featureId: reader.readLongOrNull(offsets[3]),
    featureOosZoneId: reader.readLongOrNull(offsets[4]),
    id: reader.readLongOrNull(offsets[6]),
    status: _OOSEntitystatusValueEnumMap[reader.readStringOrNull(offsets[8])] ??
        SyncStatus.isNoSynced,
    values: reader.readObjectList<OOSStatusValueEntity>(
          offsets[9],
          OOSStatusValueEntitySchema.deserialize,
          allOffsets,
          OOSStatusValueEntity(),
        ) ??
        [],
  );
  return object;
}

P _oOSEntityDeserializeProp<P>(
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
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongList(offset) ?? []) as P;
    case 8:
      return (_OOSEntitystatusValueEnumMap[reader.readStringOrNull(offset)] ??
          SyncStatus.isNoSynced) as P;
    case 9:
      return (reader.readObjectList<OOSStatusValueEntity>(
            offset,
            OOSStatusValueEntitySchema.deserialize,
            allOffsets,
            OOSStatusValueEntity(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _OOSEntitystatusEnumValueMap = {
  r'synced': r'synced',
  r'isNoSynced': r'isNoSynced',
  r'isDeleted': r'isDeleted',
};
const _OOSEntitystatusValueEnumMap = {
  r'synced': SyncStatus.synced,
  r'isNoSynced': SyncStatus.isNoSynced,
  r'isDeleted': SyncStatus.isDeleted,
};

Id _oOSEntityGetId(OOSEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _oOSEntityGetLinks(OOSEntity object) {
  return [];
}

void _oOSEntityAttach(IsarCollection<dynamic> col, Id id, OOSEntity object) {}

extension OOSEntityQueryWhereSort
    on QueryBuilder<OOSEntity, OOSEntity, QWhere> {
  QueryBuilder<OOSEntity, OOSEntity, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhere> anyKeysElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'keys'),
      );
    });
  }
}

extension OOSEntityQueryWhere
    on QueryBuilder<OOSEntity, OOSEntity, QWhereClause> {
  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> keysElementEqualTo(
      int keysElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'keys',
        value: [keysElement],
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> keysElementNotEqualTo(
      int keysElement) {
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> keysElementGreaterThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> keysElementLessThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterWhereClause> keysElementBetween(
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

extension OOSEntityQueryFilter
    on QueryBuilder<OOSEntity, OOSEntity, QFilterCondition> {
  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      attendanceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'attendanceId',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      attendanceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'attendanceId',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> attendanceIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attendanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> attendanceIdBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      dataTimestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataTimestamp',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      dataTimestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataTimestamp',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      dataTimestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataUuid',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      dataUuidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataUuid',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidEqualTo(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidGreaterThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidLessThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidStartsWith(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidEndsWith(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataUuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataUuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> dataUuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      dataUuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataUuid',
        value: '',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> featureIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'featureId',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      featureIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'featureId',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> featureIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureId',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> featureIdLessThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> featureIdBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      featureOosZoneIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'featureOosZoneId',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      featureOosZoneIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'featureOosZoneId',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      featureOosZoneIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureOosZoneId',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      featureOosZoneIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'featureOosZoneId',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      featureOosZoneIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'featureOosZoneId',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
      featureOosZoneIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'featureOosZoneId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> hashCodeGreaterThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> hashCodeLessThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> hashCodeBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> idEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> keysElementEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keys',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> keysElementLessThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> keysElementBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> keysLengthEqualTo(
      int length) {
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> keysIsEmpty() {
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> keysIsNotEmpty() {
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> keysLengthLessThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> keysLengthBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusEqualTo(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusGreaterThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusLessThan(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusBetween(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusStartsWith(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusEndsWith(
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> valuesLengthEqualTo(
      int length) {
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> valuesIsEmpty() {
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> valuesIsNotEmpty() {
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition>
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

  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> valuesLengthBetween(
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

extension OOSEntityQueryObject
    on QueryBuilder<OOSEntity, OOSEntity, QFilterCondition> {
  QueryBuilder<OOSEntity, OOSEntity, QAfterFilterCondition> valuesElement(
      FilterQuery<OOSStatusValueEntity> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'values');
    });
  }
}

extension OOSEntityQueryLinks
    on QueryBuilder<OOSEntity, OOSEntity, QFilterCondition> {}

extension OOSEntityQuerySortBy on QueryBuilder<OOSEntity, OOSEntity, QSortBy> {
  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByAttendanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceId', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByAttendanceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceId', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByDataTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataTimestamp', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByDataTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataTimestamp', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByDataUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataUuid', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByDataUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataUuid', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByFeatureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureId', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByFeatureIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureId', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByFeatureOosZoneId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureOosZoneId', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy>
      sortByFeatureOosZoneIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureOosZoneId', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension OOSEntityQuerySortThenBy
    on QueryBuilder<OOSEntity, OOSEntity, QSortThenBy> {
  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByAttendanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceId', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByAttendanceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceId', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByDataTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataTimestamp', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByDataTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataTimestamp', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByDataUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataUuid', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByDataUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataUuid', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByFeatureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureId', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByFeatureIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureId', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByFeatureOosZoneId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureOosZoneId', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy>
      thenByFeatureOosZoneIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureOosZoneId', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension OOSEntityQueryWhereDistinct
    on QueryBuilder<OOSEntity, OOSEntity, QDistinct> {
  QueryBuilder<OOSEntity, OOSEntity, QDistinct> distinctByAttendanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attendanceId');
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QDistinct> distinctByDataTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataTimestamp');
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QDistinct> distinctByDataUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataUuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QDistinct> distinctByFeatureId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'featureId');
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QDistinct> distinctByFeatureOosZoneId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'featureOosZoneId');
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QDistinct> distinctById() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id');
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QDistinct> distinctByKeys() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keys');
    });
  }

  QueryBuilder<OOSEntity, OOSEntity, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension OOSEntityQueryProperty
    on QueryBuilder<OOSEntity, OOSEntity, QQueryProperty> {
  QueryBuilder<OOSEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<OOSEntity, int?, QQueryOperations> attendanceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attendanceId');
    });
  }

  QueryBuilder<OOSEntity, DateTime?, QQueryOperations> dataTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataTimestamp');
    });
  }

  QueryBuilder<OOSEntity, String?, QQueryOperations> dataUuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataUuid');
    });
  }

  QueryBuilder<OOSEntity, int?, QQueryOperations> featureIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'featureId');
    });
  }

  QueryBuilder<OOSEntity, int?, QQueryOperations> featureOosZoneIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'featureOosZoneId');
    });
  }

  QueryBuilder<OOSEntity, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<OOSEntity, int?, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OOSEntity, List<int>, QQueryOperations> keysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keys');
    });
  }

  QueryBuilder<OOSEntity, SyncStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<OOSEntity, List<OOSStatusValueEntity>, QQueryOperations>
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

const OOSStatusValueEntitySchema = Schema(
  name: r'OOSStatusValueEntity',
  id: 6482498247998609343,
  properties: {
    r'featureOosProductId': PropertySchema(
      id: 0,
      name: r'featureOosProductId',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 1,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.long,
    ),
    r'value': PropertySchema(
      id: 3,
      name: r'value',
      type: IsarType.long,
    )
  },
  estimateSize: _oOSStatusValueEntityEstimateSize,
  serialize: _oOSStatusValueEntitySerialize,
  deserialize: _oOSStatusValueEntityDeserialize,
  deserializeProp: _oOSStatusValueEntityDeserializeProp,
);

int _oOSStatusValueEntityEstimateSize(
  OOSStatusValueEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _oOSStatusValueEntitySerialize(
  OOSStatusValueEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.featureOosProductId);
  writer.writeLong(offsets[1], object.hashCode);
  writer.writeLong(offsets[2], object.id);
  writer.writeLong(offsets[3], object.value);
}

OOSStatusValueEntity _oOSStatusValueEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OOSStatusValueEntity(
    featureOosProductId: reader.readLongOrNull(offsets[0]),
    id: reader.readLongOrNull(offsets[2]),
    value: reader.readLongOrNull(offsets[3]),
  );
  return object;
}

P _oOSStatusValueEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension OOSStatusValueEntityQueryFilter on QueryBuilder<OOSStatusValueEntity,
    OOSStatusValueEntity, QFilterCondition> {
  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> featureOosProductIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'featureOosProductId',
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> featureOosProductIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'featureOosProductId',
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> featureOosProductIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureOosProductId',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> featureOosProductIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'featureOosProductId',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> featureOosProductIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'featureOosProductId',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> featureOosProductIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'featureOosProductId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> hashCodeGreaterThan(
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

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> hashCodeLessThan(
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

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> hashCodeBetween(
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

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> idEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> valueEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> valueGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> valueLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<OOSStatusValueEntity, OOSStatusValueEntity,
      QAfterFilterCondition> valueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OOSStatusValueEntityQueryObject on QueryBuilder<OOSStatusValueEntity,
    OOSStatusValueEntity, QFilterCondition> {}

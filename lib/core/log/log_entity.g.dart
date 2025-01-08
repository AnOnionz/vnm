// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLogEntityCollection on Isar {
  IsarCollection<LogEntity> get logEntitys => this.collection();
}

const LogEntitySchema = CollectionSchema(
  name: r'LogEntity',
  id: 3974793294907107472,
  properties: {
    r'createAt': PropertySchema(
      id: 0,
      name: r'createAt',
      type: IsarType.string,
    ),
    r'requestData': PropertySchema(
      id: 1,
      name: r'requestData',
      type: IsarType.string,
    ),
    r'requestHeader': PropertySchema(
      id: 2,
      name: r'requestHeader',
      type: IsarType.string,
    ),
    r'requestURl': PropertySchema(
      id: 3,
      name: r'requestURl',
      type: IsarType.string,
    ),
    r'responseData': PropertySchema(
      id: 4,
      name: r'responseData',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 5,
      name: r'status',
      type: IsarType.string,
    )
  },
  estimateSize: _logEntityEstimateSize,
  serialize: _logEntitySerialize,
  deserialize: _logEntityDeserialize,
  deserializeProp: _logEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _logEntityGetId,
  getLinks: _logEntityGetLinks,
  attach: _logEntityAttach,
  version: '3.1.0+1',
);

int _logEntityEstimateSize(
  LogEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.createAt.length * 3;
  bytesCount += 3 + object.requestData.length * 3;
  bytesCount += 3 + object.requestHeader.length * 3;
  bytesCount += 3 + object.requestURl.length * 3;
  bytesCount += 3 + object.responseData.length * 3;
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _logEntitySerialize(
  LogEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.createAt);
  writer.writeString(offsets[1], object.requestData);
  writer.writeString(offsets[2], object.requestHeader);
  writer.writeString(offsets[3], object.requestURl);
  writer.writeString(offsets[4], object.responseData);
  writer.writeString(offsets[5], object.status);
}

LogEntity _logEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LogEntity(
    createAt: reader.readString(offsets[0]),
    requestData: reader.readString(offsets[1]),
    requestHeader: reader.readString(offsets[2]),
    requestURl: reader.readString(offsets[3]),
    responseData: reader.readString(offsets[4]),
    status: reader.readStringOrNull(offsets[5]),
  );
  object.id = id;
  return object;
}

P _logEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _logEntityGetId(LogEntity object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _logEntityGetLinks(LogEntity object) {
  return [];
}

void _logEntityAttach(IsarCollection<dynamic> col, Id id, LogEntity object) {
  object.id = id;
}

extension LogEntityQueryWhereSort
    on QueryBuilder<LogEntity, LogEntity, QWhere> {
  QueryBuilder<LogEntity, LogEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LogEntityQueryWhere
    on QueryBuilder<LogEntity, LogEntity, QWhereClause> {
  QueryBuilder<LogEntity, LogEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LogEntityQueryFilter
    on QueryBuilder<LogEntity, LogEntity, QFilterCondition> {
  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> createAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> createAtGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> createAtLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> createAtBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> createAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> createAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> createAtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> createAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> createAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      createAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createAt',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestDataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestDataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'requestData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestDataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'requestData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestDataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'requestData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'requestData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'requestData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestDataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'requestData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestDataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'requestData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestData',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'requestData',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'requestHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'requestHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'requestHeader',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'requestHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'requestHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'requestHeader',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'requestHeader',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestHeader',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestHeaderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'requestHeader',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestURlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestURl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestURlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'requestURl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestURlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'requestURl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestURlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'requestURl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestURlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'requestURl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestURlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'requestURl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestURlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'requestURl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> requestURlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'requestURl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestURlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestURl',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      requestURlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'requestURl',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> responseDataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'responseData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      responseDataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'responseData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      responseDataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'responseData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> responseDataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'responseData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      responseDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'responseData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      responseDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'responseData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      responseDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'responseData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> responseDataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'responseData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      responseDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'responseData',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition>
      responseDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'responseData',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusEqualTo(
    String? value, {
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusGreaterThan(
    String? value, {
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusLessThan(
    String? value, {
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusStartsWith(
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusEndsWith(
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusContains(
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusMatches(
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

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }
}

extension LogEntityQueryObject
    on QueryBuilder<LogEntity, LogEntity, QFilterCondition> {}

extension LogEntityQueryLinks
    on QueryBuilder<LogEntity, LogEntity, QFilterCondition> {}

extension LogEntityQuerySortBy on QueryBuilder<LogEntity, LogEntity, QSortBy> {
  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByRequestData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestData', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByRequestDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestData', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByRequestHeader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestHeader', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByRequestHeaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestHeader', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByRequestURl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestURl', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByRequestURlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestURl', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByResponseData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseData', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByResponseDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseData', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension LogEntityQuerySortThenBy
    on QueryBuilder<LogEntity, LogEntity, QSortThenBy> {
  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByRequestData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestData', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByRequestDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestData', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByRequestHeader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestHeader', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByRequestHeaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestHeader', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByRequestURl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestURl', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByRequestURlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestURl', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByResponseData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseData', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByResponseDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'responseData', Sort.desc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension LogEntityQueryWhereDistinct
    on QueryBuilder<LogEntity, LogEntity, QDistinct> {
  QueryBuilder<LogEntity, LogEntity, QDistinct> distinctByCreateAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QDistinct> distinctByRequestData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requestData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QDistinct> distinctByRequestHeader(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requestHeader',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QDistinct> distinctByRequestURl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requestURl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QDistinct> distinctByResponseData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'responseData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LogEntity, LogEntity, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension LogEntityQueryProperty
    on QueryBuilder<LogEntity, LogEntity, QQueryProperty> {
  QueryBuilder<LogEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LogEntity, String, QQueryOperations> createAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createAt');
    });
  }

  QueryBuilder<LogEntity, String, QQueryOperations> requestDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requestData');
    });
  }

  QueryBuilder<LogEntity, String, QQueryOperations> requestHeaderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requestHeader');
    });
  }

  QueryBuilder<LogEntity, String, QQueryOperations> requestURlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requestURl');
    });
  }

  QueryBuilder<LogEntity, String, QQueryOperations> responseDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'responseData');
    });
  }

  QueryBuilder<LogEntity, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}

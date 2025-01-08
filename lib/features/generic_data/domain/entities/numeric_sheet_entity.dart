// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vnm/core/mixins/extension/string_ext.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/general/domain/entities/data_entity.dart';
import 'package:isar/isar.dart';

import '../../../../core/constant/enum.dart';
import '../../../../core/utilities/parser.dart';

part 'numeric_sheet_entity.g.dart';

@collection
class NumericSheetEntity extends BaseEntity {
  Id get isarId => fastHash(keys.join('-'));
  final int? id;
  String? dataUuid;
  int? attendanceId;
  int? featureId;
  DateTime? dataTimestamp;
  final List<NumericValueEntity> values;
  @Enumerated(EnumType.name)
  SyncStatus status;
  NumericSheetEntity({
    this.id,
    this.dataUuid,
    this.attendanceId,
    this.featureId,
    this.dataTimestamp,
    required this.values,
    this.status = SyncStatus.isNoSynced,
  });
  @Index(type: IndexType.value)
  List<int> get keys => [attendanceId!, featureId!];

  NumericSheetEntity copyWith({
    int? id,
    String? dataUuid,
    int? attendanceId,
    int? featureId,
    DateTime? dataTimestamp,
    List<NumericValueEntity>? values,
    SyncStatus? status,
  }) {
    return NumericSheetEntity(
      id: id ?? this.id,
      dataUuid: dataUuid ?? this.dataUuid,
      attendanceId: attendanceId ?? this.attendanceId,
      featureId: featureId ?? this.featureId,
      dataTimestamp: dataTimestamp ?? this.dataTimestamp,
      values: values ?? this.values,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dataUuid': dataUuid,
      'dataTimestamp': dataTimestamp!.toUtc().toIso8601String(),
      'values': values.map((x) => x.toMap()).toList(),
    };
  }

  factory NumericSheetEntity.fromMap(Map<String, dynamic> map) {
    return NumericSheetEntity(
      id: map['id'] != null ? map['id'] as int : null,
      dataUuid: map['dataUuid'] as String,
      attendanceId:
          map['attendanceId'] != null ? map['attendanceId'] as int : null,
      featureId: map['featureId'] != null ? map['featureId'] as int : null,
      dataTimestamp: DateTime.parse(map['dataTimestamp'] as String).toLocal(),
      values: List<NumericValueEntity>.from(
        (map['values'] as List<dynamic>).map<NumericValueEntity>(
          (x) => NumericValueEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NumericSheetEntity.fromJson(String source) =>
      NumericSheetEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NumericSheetEntity(id: $id, dataUuid: $dataUuid, attendanceId: $attendanceId, featureId: $featureId, dataTimestamp: $dataTimestamp, values: $values, status: $status)';
  }

  @override
  bool operator ==(covariant NumericSheetEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dataUuid == dataUuid &&
        other.attendanceId == attendanceId &&
        other.featureId == featureId &&
        other.dataTimestamp == dataTimestamp &&
        listEquals(other.values, values) &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataUuid.hashCode ^
        attendanceId.hashCode ^
        featureId.hashCode ^
        dataTimestamp.hashCode ^
        values.hashCode ^
        status.hashCode;
  }
}

@embedded
class NumericValueEntity {
  final int? id;
  final int? featureNumericId;
  final int? featureNumericAttributeId;
  final String? value;

  NumericValueEntity({
    this.id,
    this.featureNumericId,
    this.featureNumericAttributeId,
    this.value,
  });

  bool checkInvalid(
      {required FeatureNumericAttribute featureNumericAttribute}) {
    final min = featureNumericAttribute.minimum.toNum();
    final max = featureNumericAttribute.maximum.toNum();

    if (min != null && !value.isEmptyOrNull && value.toNum()! < min) {
      return true;
    }
    if (max != null && !value.isEmptyOrNull && value.toNum()! > max) {
      return true;
    }
    return false;
  }

  NumericValueEntity copyWith({
    int? id,
    int? featureNumericId,
    int? featureNumericAttributeId,
    String? value,
  }) {
    return NumericValueEntity(
      id: id ?? this.id,
      featureNumericId: featureNumericId ?? this.featureNumericId,
      featureNumericAttributeId:
          featureNumericAttributeId ?? this.featureNumericAttributeId,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'featureNumericId': featureNumericId,
      'featureNumericAttributeId': featureNumericAttributeId,
      'value': value.toNum(),
    };
  }

  factory NumericValueEntity.fromMap(Map<String, dynamic> map) {
    return NumericValueEntity(
      id: map['id'] != null ? map['id'] as int : null,
      featureNumericId: map['featureNumericId'] != null
          ? map['featureNumericId'] as int
          : null,
      featureNumericAttributeId: map['featureNumericAttributeId'] != null
          ? map['featureNumericAttributeId'] as int
          : null,
      value: map['value'] != null ? map['value'].toString() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NumericValueEntity.fromJson(String source) =>
      NumericValueEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NumericValueEntity(id: $id, featureNumericId: $featureNumericId, featureNumericAttributeId: $featureNumericAttributeId, value: $value)';
  }

  @override
  bool operator ==(covariant NumericValueEntity other) {
    if (identical(this, other)) return true;

    return other.featureNumericId == featureNumericId &&
        other.featureNumericAttributeId == featureNumericAttributeId;
  }

  @override
  int get hashCode {
    return featureNumericId.hashCode ^ featureNumericAttributeId.hashCode;
  }
}

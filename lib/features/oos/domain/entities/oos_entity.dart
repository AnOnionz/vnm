// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/utilities/parser.dart';
import 'package:vnm/features/general/domain/entities/data_entity.dart';
import 'package:vnm/features/oos/data/models/oos_model.dart';
import 'package:isar/isar.dart';

part 'oos_entity.g.dart';

@collection
class OOSEntity extends BaseEntity {
  Id get isarId => fastHash(keys.join('-'));
  final int? id;
  String? dataUuid;
  int? attendanceId;
  int? featureId;
  DateTime? dataTimestamp;
  final int? featureOosZoneId;
  final List<OOSStatusValueEntity> values;
  @Enumerated(EnumType.name)
  SyncStatus status;
  OOSEntity({
    this.id,
    this.dataUuid,
    this.attendanceId,
    this.featureId,
    this.dataTimestamp,
    this.featureOosZoneId,
    required this.values,
    this.status = SyncStatus.isNoSynced,
  });

  @Index(type: IndexType.value)
  List<int> get keys => [attendanceId!, featureId!];

  OOSEntity copyWith({
    int? id,
    String? dataUuid,
    int? attendanceId,
    int? featureId,
    DateTime? dataTimestamp,
    int? featureOosZoneId,
    List<OOSStatusValueEntity>? values,
    SyncStatus? status,
  }) {
    return OOSEntity(
      id: id ?? this.id,
      dataUuid: dataUuid ?? this.dataUuid,
      attendanceId: attendanceId ?? this.attendanceId,
      featureId: featureId ?? this.featureId,
      dataTimestamp: dataTimestamp ?? this.dataTimestamp,
      featureOosZoneId: featureOosZoneId ?? this.featureOosZoneId,
      values: values ?? this.values,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dataUuid': dataUuid,
      'dataTimestamp': dataTimestamp!.toUtc().toIso8601String(),
      'featureOosZoneId': featureOosZoneId,
      'values': values.map((x) => x.toMap()).toList(),
    };
  }

  factory OOSEntity.fromMap(Map<String, dynamic> map) {
    return OOSEntity(
      id: map['id'] != null ? map['id'] as int : null,
      dataUuid: map['dataUuid'] != null ? map['dataUuid'] as String : null,
      attendanceId:
          map['attendanceId'] != null ? map['attendanceId'] as int : null,
      featureId: map['featureId'] != null ? map['featureId'] as int : null,
      featureOosZoneId: map['featureOosZoneId'] != null
          ? map['featureOosZoneId'] as int
          : null,
      dataTimestamp: map['dataTimestamp'] != null
          ? DateTime.parse(map['dataTimestamp'] as String).toLocal()
          : null,
      values: List<OOSStatusValueEntity>.from(
        (map['values'] as List<dynamic>).map<OOSStatusValueEntity>(
          (x) => OOSStatusValueEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  OOSModel toModel() {
    return OOSModel(
      id: id,
      attendanceId: attendanceId,
      dataUuid: dataUuid,
      dataTimestamp: dataTimestamp,
      featureId: featureId,
      featureOosZoneId: featureOosZoneId,
      status: status,
      values: values,
    );
  }

  String toJson() => json.encode(toMap());

  factory OOSEntity.fromJson(String source) =>
      OOSEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant OOSEntity other) {
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

  @override
  String toString() {
    return 'OOSEntity(id: $id, dataUuid: $dataUuid, attendanceId: $attendanceId, featureId: $featureId, dataTimestamp: $dataTimestamp, featureOosZoneId: $featureOosZoneId, values: $values, status: $status)';
  }
}

@embedded
class OOSStatusValueEntity {
  final int? id;
  final int? featureOosProductId;
  final int? value;
  OOSStatusValueEntity({
    this.id,
    this.featureOosProductId,
    this.value,
  });

  OOSStatusValueEntity copyWith({
    int? id,
    int? featureOosProductId,
    int? value,
  }) {
    return OOSStatusValueEntity(
      id: id ?? this.id,
      featureOosProductId: featureOosProductId ?? this.featureOosProductId,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'featureOosProductId': featureOosProductId,
      'value': value,
    };
  }

  factory OOSStatusValueEntity.fromMap(Map<String, dynamic> map) {
    return OOSStatusValueEntity(
      id: map['id'] != null ? map['id'] as int : null,
      featureOosProductId: map['featureOosProductId'] != null
          ? map['featureOosProductId'] as int
          : null,
      value: map['value'] != null ? map['value'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OOSStatusValueEntity.fromJson(String source) =>
      OOSStatusValueEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OOSStatusValueEntity(id: $id, featureOosProductId: $featureOosProductId, value: $value)';

  @override
  bool operator ==(covariant OOSStatusValueEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.featureOosProductId == featureOosProductId &&
        other.value == value;
  }

  @override
  int get hashCode =>
      id.hashCode ^ featureOosProductId.hashCode ^ value.hashCode;
}

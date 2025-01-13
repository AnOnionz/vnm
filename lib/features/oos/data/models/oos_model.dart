import 'package:fms/features/oos/domain/entities/oos_entity.dart';

class OOSModel extends OOSEntity {
  OOSModel(
      {super.id,
      super.dataUuid,
      super.dataTimestamp,
      super.featureOosZoneId,
      super.attendanceId,
      super.featureId,
      super.status,
      required super.values});

  factory OOSModel.fromMap(Map<String, dynamic> map) {
    return OOSModel(
        id: map['id'] as int,
        dataUuid: map['dataUuid'] as String,
        dataTimestamp: DateTime.parse(map['dataTimestamp'] as String).toLocal(),
        values: (map['values'] as List<dynamic>)
            .map((e) => OOSStatusValueEntity.fromMap(e as Map<String, dynamic>))
            .toList(),
        featureOosZoneId: map['featureOosZoneId'] != null
            ? map['featureOosZoneId'] as int
            : null);
  }
}

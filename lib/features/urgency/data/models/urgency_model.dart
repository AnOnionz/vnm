import 'package:vnm/features/urgency/domain/entities/urgency_entity.dart';

import '../../../general/domain/entities/config_entity.dart';
import '../../../statistic/domain/entities/employee_entity.dart';

class UrgencyModel extends UrgencyEntity {
  UrgencyModel(
      {required super.id,
      required super.featureUrgencyId,
      required super.startAt,
      super.featureUrgency,
      super.user,
      super.endAt,
      super.note});

  factory UrgencyModel.fromMap(Map<String, dynamic> map) {
    return UrgencyModel(
      id: map['id'] as int,
      featureUrgencyId: map['featureUrgencyId'] as int,
      startAt: DateTime.parse(map['startAt'] as String).toLocal(),
      featureUrgency: map['featureUrgency'] != null
          ? FeatureUrgency.fromMap(
              map['featureUrgency'] as Map<String, dynamic>)
          : null,
      user: map['user'] != null
          ? EmployeeUserEntity.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      endAt: map['endAt'] != null
          ? DateTime.parse(map['endAt'] as String).toLocal()
          : null,
      note: map['note'] != null ? map['note'] as String : null,
    );
  }
}

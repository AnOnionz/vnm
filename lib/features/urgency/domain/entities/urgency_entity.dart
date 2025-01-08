// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:vnm/features/statistic/domain/entities/employee_entity.dart';

import '../../../general/domain/entities/config_entity.dart';

class UrgencyEntity {
  final int id;
  final EmployeeUserEntity? user;
  final int featureUrgencyId;
  final FeatureUrgency? featureUrgency;
  final DateTime startAt;
  final DateTime? endAt;
  final String? note;
  UrgencyEntity({
    required this.id,
    this.user,
    required this.featureUrgencyId,
    this.featureUrgency,
    required this.startAt,
    this.endAt,
    this.note,
  });

  UrgencyEntity copyWith({
    int? id,
    EmployeeUserEntity? user,
    int? featureUrgencyId,
    FeatureUrgency? featureUrgency,
    DateTime? startAt,
    DateTime? endAt,
    String? note,
  }) {
    return UrgencyEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      featureUrgencyId: featureUrgencyId ?? this.featureUrgencyId,
      featureUrgency: featureUrgency ?? this.featureUrgency,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user?.toMap(),
      'featureUrgencyId': featureUrgencyId,
      'featureUrgency': featureUrgency?.toMap(),
      'startAt': startAt,
      'endAt': endAt,
      'note': note,
    };
  }

  factory UrgencyEntity.fromMap(Map<String, dynamic> map) {
    return UrgencyEntity(
      id: map['id'] as int,
      user: map['user'] != null
          ? EmployeeUserEntity.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      featureUrgencyId: map['featureUrgencyId'] as int,
      featureUrgency: map['featureUrgency'] != null
          ? FeatureUrgency.fromMap(
              map['featureUrgency'] as Map<String, dynamic>)
          : null,
      startAt: DateTime.parse(map['startAt'] as String).toLocal(),
      endAt: map['endAt'] != null
          ? DateTime.parse(map['endAt'] as String).toLocal()
          : null,
      note: map['note'] != null ? map['note'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UrgencyEntity.fromJson(String source) =>
      UrgencyEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UrgencyEntity(id: $id, user: $user, featureUrgencyId: $featureUrgencyId, featureUrgency: $featureUrgency, startAt: $startAt, endAt: $endAt, note: $note)';
  }

  @override
  bool operator ==(covariant UrgencyEntity other) {
    if (identical(this, other)) return true;

    return other.id == id && other.featureUrgencyId == featureUrgencyId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ featureUrgencyId.hashCode;
  }
}

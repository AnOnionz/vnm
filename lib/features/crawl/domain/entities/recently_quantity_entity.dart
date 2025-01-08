import 'dart:convert';

import 'package:vnm/features/general/domain/entities/config_entity.dart';

class RecentlyQuantityEntity {
  final FeatureQuantity featureQuantity;
  final int? value;

  RecentlyQuantityEntity({
    required this.featureQuantity,
    this.value,
  });

  RecentlyQuantityEntity copyWith({
    FeatureQuantity? featureQuantity,
    int? value,
  }) {
    return RecentlyQuantityEntity(
      featureQuantity: featureQuantity ?? this.featureQuantity,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'featureQuantity': featureQuantity.toMap(),
      'value': value,
    };
  }

  factory RecentlyQuantityEntity.fromMap(Map<String, dynamic> map) {
    return RecentlyQuantityEntity(
      featureQuantity: FeatureQuantity.fromMap(
          map['featureQuantity'] as Map<String, dynamic>),
      value: map['value'] != null ? map['value'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecentlyQuantityEntity.fromJson(String source) =>
      RecentlyQuantityEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RecentlyQuantityEntity(featureQuantity: $featureQuantity, value: $value)';

  @override
  bool operator ==(covariant RecentlyQuantityEntity other) {
    if (identical(this, other)) return true;

    return other.featureQuantity == featureQuantity && other.value == value;
  }

  @override
  int get hashCode => featureQuantity.hashCode ^ value.hashCode;
}

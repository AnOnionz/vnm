import 'dart:convert';

import 'package:isar/isar.dart';
part 'customer_verification_code_entity.g.dart';

@embedded
class CustomerVerificationCodeEntity {
  final int? id;
  CustomerVerificationCodeEntity({
    this.id,
  });

  CustomerVerificationCodeEntity copyWith({
    int? id,
  }) {
    return CustomerVerificationCodeEntity(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': id,
    };
  }

  factory CustomerVerificationCodeEntity.fromMap(Map<String, dynamic> map) {
    return CustomerVerificationCodeEntity(
      id: map['id'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerVerificationCodeEntity.fromJson(String source) =>
      CustomerVerificationCodeEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VerificationCodeCustomer(id: $id)';

  @override
  bool operator ==(covariant CustomerVerificationCodeEntity other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

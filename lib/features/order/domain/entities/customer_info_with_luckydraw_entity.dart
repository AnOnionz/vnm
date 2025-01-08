import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:vnm/features/general/domain/entities/config_entity.dart';

class CustomerInfoWithLuckyDrawEntity {
  final List<CustomerInfoField> customerInfoFields;
  final List<CustomerLuckyDraw> customerLuckyDraws;

  CustomerInfoWithLuckyDrawEntity({
    required this.customerInfoFields,
    required this.customerLuckyDraws,
  });

  CustomerInfoWithLuckyDrawEntity copyWith({
    List<CustomerInfoField>? customerInfoFields,
    List<CustomerLuckyDraw>? customerLuckyDraws,
  }) {
    return CustomerInfoWithLuckyDrawEntity(
      customerInfoFields: customerInfoFields ?? this.customerInfoFields,
      customerLuckyDraws: customerLuckyDraws ?? this.customerLuckyDraws,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customerInfoFields': customerInfoFields.map((x) => x.toMap()).toList(),
      'customerLuckyDraws': customerLuckyDraws.map((x) => x.toMap()).toList(),
    };
  }

  factory CustomerInfoWithLuckyDrawEntity.fromMap(Map<String, dynamic> map) {
    return CustomerInfoWithLuckyDrawEntity(
      customerInfoFields: List<CustomerInfoField>.from(
        (map['customerInfoFields'] as List<dynamic>).map<CustomerInfoField>(
          (x) => CustomerInfoField.fromMap(x as Map<String, dynamic>),
        ),
      ),
      customerLuckyDraws: List<CustomerLuckyDraw>.from(
        (map['customerLuckyDraws'] as List<dynamic>).map<CustomerLuckyDraw>(
          (x) => CustomerLuckyDraw.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerInfoWithLuckyDrawEntity.fromJson(String source) =>
      CustomerInfoWithLuckyDrawEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CustomerInfoWithLuckyDraw(customerInfoFields: $customerInfoFields, customerLuckyDraws: $customerLuckyDraws)';

  @override
  bool operator ==(covariant CustomerInfoWithLuckyDrawEntity other) {
    if (identical(this, other)) return true;

    return listEquals(other.customerInfoFields, customerInfoFields) &&
        listEquals(other.customerLuckyDraws, customerLuckyDraws);
  }

  @override
  int get hashCode => customerInfoFields.hashCode ^ customerLuckyDraws.hashCode;
}

class CustomerInfoField {
  final int id;
  final String label;
  final String? value;

  CustomerInfoField({
    required this.id,
    required this.label,
    this.value,
  });

  CustomerInfoField copyWith({
    int? id,
    String? label,
    String? value,
  }) {
    return CustomerInfoField(
      id: id ?? this.id,
      label: label ?? this.label,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'value': value,
    };
  }

  factory CustomerInfoField.fromMap(Map<String, dynamic> map) {
    return CustomerInfoField(
      id: map['id'] as int,
      label: map['label'] as String,
      value: map['value'] != null ? map['value'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerInfoField.fromJson(String source) =>
      CustomerInfoField.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CustomerInfoField(id: $id, label: $label, value: $value)';

  @override
  bool operator ==(covariant CustomerInfoField other) {
    if (identical(this, other)) return true;

    return other.id == id && other.label == label && other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ label.hashCode ^ value.hashCode;
}

class CustomerLuckyDraw {
  final int id;
  final String name;
  final String? description;
  final int availableTurns;
  final List<PrizeItem> prizeItems;
  final List<PrizeResult> prizeResults;

  CustomerLuckyDraw({
    required this.id,
    required this.name,
    this.description,
    required this.availableTurns,
    required this.prizeItems,
    required this.prizeResults,
  });

  CustomerLuckyDraw copyWith({
    int? id,
    String? name,
    String? description,
    int? availableTurns,
    List<PrizeItem>? prizeItems,
    List<PrizeResult>? prizeResults,
  }) {
    return CustomerLuckyDraw(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      availableTurns: availableTurns ?? this.availableTurns,
      prizeItems: prizeItems ?? this.prizeItems,
      prizeResults: prizeResults ?? this.prizeResults,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'availableTurns': availableTurns,
      'prizeItems': prizeItems.map((x) => x.toMap()).toList(),
      'prizeResults': prizeResults.map((x) => x.toMap()).toList(),
    };
  }

  factory CustomerLuckyDraw.fromMap(Map<String, dynamic> map) {
    return CustomerLuckyDraw(
      id: map['id'] as int,
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      availableTurns: map['availableTurns'] as int,
      prizeItems: List<PrizeItem>.from(
        (map['prizeItems'] as List<dynamic>).map<PrizeItem>(
          (x) => PrizeItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
      prizeResults: List<PrizeResult>.from(
        (map['prizeResults'] as List<dynamic>).map<PrizeResult>(
          (x) => PrizeResult.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerLuckyDraw.fromJson(String source) =>
      CustomerLuckyDraw.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerLuckyDraw(id: $id, name: $name, description: $description, availableTurns: $availableTurns, prizeItems: $prizeItems, prizeResults: $prizeResults)';
  }

  @override
  bool operator ==(covariant CustomerLuckyDraw other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.availableTurns == availableTurns &&
        listEquals(other.prizeItems, prizeItems) &&
        listEquals(other.prizeResults, prizeResults);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        availableTurns.hashCode ^
        prizeItems.hashCode ^
        prizeResults.hashCode;
  }
}

class PrizeItem {
  final int id;
  final int ordinal;
  final ProjectItem projectItem;

  PrizeItem({
    required this.id,
    required this.ordinal,
    required this.projectItem,
  });

  PrizeItem copyWith({
    int? id,
    int? ordinal,
    ProjectItem? projectItem,
  }) {
    return PrizeItem(
      id: id ?? this.id,
      ordinal: ordinal ?? this.ordinal,
      projectItem: projectItem ?? this.projectItem,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'ordinal': ordinal,
      'projectItem': projectItem.toMap(),
    };
  }

  factory PrizeItem.fromMap(Map<String, dynamic> map) {
    return PrizeItem(
      id: map['id'] as int,
      ordinal: map['ordinal'] as int,
      projectItem:
          ProjectItem.fromMap(map['projectItem'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PrizeItem.fromJson(String source) =>
      PrizeItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PrizeItem(id: $id, ordinal: $ordinal, projectItem: $projectItem)';

  @override
  bool operator ==(covariant PrizeItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.ordinal == ordinal &&
        other.projectItem == projectItem;
  }

  @override
  int get hashCode => id.hashCode ^ ordinal.hashCode ^ projectItem.hashCode;
}

class ProjectItem {
  final int id;
  final Item? item;

  ProjectItem({
    required this.id,
    this.item,
  });

  ProjectItem copyWith({
    int? id,
    Item? item,
  }) {
    return ProjectItem(
      id: id ?? this.id,
      item: item ?? this.item,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'item': item?.toMap(),
    };
  }

  factory ProjectItem.fromMap(Map<String, dynamic> map) {
    return ProjectItem(
      id: map['id'] as int,
      item: map['item'] != null
          ? Item.fromMap(map['item'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectItem.fromJson(String source) =>
      ProjectItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ProjectItem(id: $id, item: $item)';

  @override
  bool operator ==(covariant ProjectItem other) {
    if (identical(this, other)) return true;

    return other.id == id && other.item == item;
  }

  @override
  int get hashCode => id.hashCode ^ item.hashCode;
}

class PrizeResult {
  final int id;
  final DateTime createdAt;
  final int prizeItemId;

  PrizeResult({
    required this.id,
    required this.createdAt,
    required this.prizeItemId,
  });

  PrizeResult copyWith({
    int? id,
    DateTime? createdAt,
    int? prizeItemId,
  }) {
    return PrizeResult(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      prizeItemId: prizeItemId ?? this.prizeItemId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'prizeItemId': prizeItemId,
    };
  }

  factory PrizeResult.fromMap(Map<String, dynamic> map) {
    return PrizeResult(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String).toLocal(),
      prizeItemId: map['prizeItemId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrizeResult.fromJson(String source) =>
      PrizeResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PrizeResult(id: $id, createdAt: $createdAt, prizeItemId: $prizeItemId)';

  @override
  bool operator ==(covariant PrizeResult other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.prizeItemId == prizeItemId;
  }

  @override
  int get hashCode => id.hashCode ^ createdAt.hashCode ^ prizeItemId.hashCode;
}

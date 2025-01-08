// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:vnm/core/mixins/extension/string_ext.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/work_place/domain/entities/booth_entity.dart';

import '../../../../core/constant/enum.dart';
import '../../../work_place/domain/entities/outlet_entity.dart';
import 'order_entity.dart';

class CustomerIdentity {
  final List<RemainingQuota> remainingQuotas;
  final List<CustomerInfo> customerInfos;
  final List<CustomerOrderHistory> customerOrderHistorys;

  CustomerIdentity(
      {required this.remainingQuotas,
      required this.customerInfos,
      required this.customerOrderHistorys});

  factory CustomerIdentity.empty() {
    return CustomerIdentity(
        customerInfos: [], remainingQuotas: [], customerOrderHistorys: []);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'remainingQuotas': remainingQuotas.map((x) => x.toMap()).toList(),
      'customerInfos': customerInfos.map((x) => x.toMap()).toList(),
    };
  }

  factory CustomerIdentity.fromMap(Map<String, dynamic> map) {
    return CustomerIdentity(
        remainingQuotas: List<RemainingQuota>.from(
          (map['remainingQuotas'] as List<dynamic>).map<RemainingQuota>(
            (x) => RemainingQuota.fromMap(x as Map<String, dynamic>),
          ),
        ),
        customerInfos: map['customer'] != null
            ? List<CustomerInfo>.from(
                (map['customer']['customerInfos'] as List<dynamic>)
                    .map<CustomerInfo>(
                  (x) => CustomerInfo.fromMap(x as Map<String, dynamic>),
                ),
              )
            : [],
        customerOrderHistorys: map['customerOrderHistory'] != null
            ? List<CustomerOrderHistory>.from(
                (map['customerOrderHistory'] as List<dynamic>)
                    .map<CustomerOrderHistory>(
                  (x) =>
                      CustomerOrderHistory.fromMap(x as Map<String, dynamic>),
                ),
              )
            : []);
  }

  String toJson() => json.encode(toMap());

  factory CustomerIdentity.fromJson(String source) =>
      CustomerIdentity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IdentityOfCustomer(remainingQuotas: $remainingQuotas, customerInfos: $customerInfos)';

  CustomerIdentity copyWith(
      {List<RemainingQuota>? remainingQuotas,
      List<CustomerInfo>? customerInfos,
      List<CustomerOrderHistory>? customerOrderHistorys}) {
    return CustomerIdentity(
        remainingQuotas: remainingQuotas ?? this.remainingQuotas,
        customerInfos: customerInfos ?? this.customerInfos,
        customerOrderHistorys:
            customerOrderHistorys ?? this.customerOrderHistorys);
  }

  @override
  bool operator ==(covariant CustomerIdentity other) {
    if (identical(this, other)) return true;

    return listEquals(other.remainingQuotas, remainingQuotas) &&
        listEquals(other.customerInfos, customerInfos);
  }

  @override
  int get hashCode => remainingQuotas.hashCode ^ customerInfos.hashCode;
}

class RemainingQuota {
  final int? id;
  final QuotaType? type;
  final int? remainingQuantity;

  RemainingQuota({
    this.id,
    this.type,
    this.remainingQuantity,
  });

  RemainingQuota copyWith({
    int? id,
    QuotaType? type,
    int? remainingQuantity,
  }) {
    return RemainingQuota(
      id: id ?? this.id,
      type: type ?? this.type,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'remainingQuantity': remainingQuantity,
    };
  }

  factory RemainingQuota.fromMap(Map<String, dynamic> map) {
    return RemainingQuota(
      id: map['id'] != null ? map['id'] as int : null,
      type: map['type'] != null ? (map['type'] as String).toQuotaType() : null,
      remainingQuantity: map['remainingQuantity'] != null
          ? map['remainingQuantity'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemainingQuota.fromJson(String source) =>
      RemainingQuota.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RemainingQuota(id: $id, type: $type, remainingQuantity: $remainingQuantity)';

  @override
  bool operator ==(covariant RemainingQuota other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.remainingQuantity == remainingQuantity;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ remainingQuantity.hashCode;
}

class CustomerOrderHistory {
  final int id;
  final String dataTimestamp;
  final OutletEntity projectOutlet;
  final BoothEntity projectBooth;
  final List<ExchangeEntity> exchanges;
  final List<OrderSamplingEntity> samplings;
  final List<CustomerOrderPrizeHistory> prizes;

  CustomerOrderHistory(
    this.id,
    this.dataTimestamp,
    this.projectOutlet,
    this.projectBooth,
    this.exchanges,
    this.samplings,
    this.prizes,
  );

  CustomerOrderHistory copyWith({
    int? id,
    String? dataTimestamp,
    OutletEntity? projectOutlet,
    BoothEntity? projectBooth,
    List<ExchangeEntity>? exchanges,
    List<OrderSamplingEntity>? samplings,
    List<CustomerOrderPrizeHistory>? prizes,
  }) {
    return CustomerOrderHistory(
      id ?? this.id,
      dataTimestamp ?? this.dataTimestamp,
      projectOutlet ?? this.projectOutlet,
      projectBooth ?? this.projectBooth,
      exchanges ?? this.exchanges,
      samplings ?? this.samplings,
      prizes ?? this.prizes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dataTimestamp': dataTimestamp,
      'projectOutlet': projectOutlet.toMap(),
      'projectBooth': projectBooth.toMap(),
      'exchanges': exchanges.map((x) => x.toMap()).toList(),
      'samplings': samplings.map((x) => x.toMap()).toList(),
      'prizes': prizes.map((x) => x.toMap()).toList(),
    };
  }

  factory CustomerOrderHistory.fromMap(Map<String, dynamic> map) {
    return CustomerOrderHistory(
      map['id'] as int,
      map['dataTimestamp'] as String,
      OutletEntity.fromMap(map['projectOutlet'] as Map<String, dynamic>),
      BoothEntity.fromMap(map['projectBooth'] as Map<String, dynamic>),
      List<ExchangeEntity>.from(
        (map['exchanges'] as List<dynamic>).map<ExchangeEntity>(
          (x) => ExchangeEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      List<OrderSamplingEntity>.from(
        (map['samplings'] as List<dynamic>).map<OrderSamplingEntity>(
          (x) => OrderSamplingEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      List<CustomerOrderPrizeHistory>.from(
        (map['prizes'] as List<dynamic>).map<CustomerOrderPrizeHistory>(
          (x) => CustomerOrderPrizeHistory.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerOrderHistory.fromJson(String source) =>
      CustomerOrderHistory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerOrderHistory(id: $id, dataTimestamp: $dataTimestamp, projectOutlet: $projectOutlet, projectBooth: $projectBooth, exchanges: $exchanges, samplings: $samplings, prizes: $prizes)';
  }

  @override
  bool operator ==(covariant CustomerOrderHistory other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dataTimestamp == dataTimestamp &&
        other.projectOutlet == projectOutlet &&
        other.projectBooth == projectBooth &&
        listEquals(other.exchanges, exchanges) &&
        listEquals(other.samplings, samplings) &&
        listEquals(other.prizes, prizes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dataTimestamp.hashCode ^
        projectOutlet.hashCode ^
        projectBooth.hashCode ^
        exchanges.hashCode ^
        samplings.hashCode ^
        prizes.hashCode;
  }
}

class CustomerOrderPrizeHistory {
  final int id;
  final LuckyDrawEntity luckyDraw;
  final Item item;
  CustomerOrderPrizeHistory({
    required this.id,
    required this.luckyDraw,
    required this.item,
  });

  CustomerOrderPrizeHistory copyWith({
    int? id,
    LuckyDrawEntity? luckyDraw,
    Item? item,
  }) {
    return CustomerOrderPrizeHistory(
      id: id ?? this.id,
      luckyDraw: luckyDraw ?? this.luckyDraw,
      item: item ?? this.item,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'luckyDraw': luckyDraw.toMap(),
      'item': item.toMap(),
    };
  }

  factory CustomerOrderPrizeHistory.fromMap(Map<String, dynamic> map) {
    return CustomerOrderPrizeHistory(
      id: map['id'] as int,
      luckyDraw:
          LuckyDrawEntity.fromMap(map['luckyDraw'] as Map<String, dynamic>),
      item: Item.fromMap(map['item'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerOrderPrizeHistory.fromJson(String source) =>
      CustomerOrderPrizeHistory.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CustomerOrderPrizeHistory(id: $id, luckyDraw: $luckyDraw, item: $item)';

  @override
  bool operator ==(covariant CustomerOrderPrizeHistory other) {
    if (identical(this, other)) return true;

    return other.id == id && other.luckyDraw == luckyDraw && other.item == item;
  }

  @override
  int get hashCode => id.hashCode ^ luckyDraw.hashCode ^ item.hashCode;
}

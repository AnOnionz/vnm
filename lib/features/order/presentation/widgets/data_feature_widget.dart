import 'package:flutter/material.dart';
import 'package:fms/features/order/domain/entities/order_entity.dart';

import '../../../home/domain/entities/general_item_data.dart';
import '../../domain/entities/customer_identity.dart';

class DataFeature extends InheritedWidget {
  const DataFeature({
    super.key,
    required this.data,
    required this.order,
    required this.quotas,
    required this.customerOrderHistorys,
    required super.child,
  });

  final GeneralFeatureData data;
  final OrderEntity order;
  final List<RemainingQuota> quotas;
  final List<CustomerOrderHistory> customerOrderHistorys;

  static DataFeature? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataFeature>();
  }

  static DataFeature of(BuildContext context) {
    final DataFeature? result = maybeOf(context);
    assert(result != null, 'No DataFeature found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DataFeature oldWidget) =>
      data != oldWidget.data && order != oldWidget.order;
}

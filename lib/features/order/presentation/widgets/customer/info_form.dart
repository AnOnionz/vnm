import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fms/core/mixins/extension/iterable_ext.dart';
import 'package:fms/core/responsive/responsive.dart';
import '../../../../general/domain/entities/config_entity.dart';
import '../../../domain/entities/order_entity.dart';
import 'customer_field.dart';

class InfomationForm extends StatefulWidget {
  final GlobalKey formKey;
  final Map<FeatureCustomer, CustomerInfo> fields;
  final Function(Map<FeatureCustomer, CustomerInfo> fields) onFieldChanged;

  const InfomationForm(
      {super.key,
      required this.formKey,
      required this.fields,
      required this.onFieldChanged});

  @override
  State<InfomationForm> createState() => _InfomationFormState();
}

class _InfomationFormState extends State<InfomationForm>
    with AutomaticKeepAliveClientMixin {
  // late final _fields = widget.fields.entries
  //     .where((field) => !field.key.isIdentity!)
  //     .map((e) => MapEntry(e.key, e.value.copyWith()))
  //     .toList();
  late final _fields = Map<FeatureCustomer, CustomerInfo>.from(
      widget.fields..removeWhere((key, value) => key.isIdentity!));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._fields.entries
                .where((field) => !field.key.isIdentity!)
                .toList()
                .mapIndexed((index, entry) {
              final isLast = index == _fields.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 18.h),
                child: CustomerField(
                  onChanged: (newCustomerInfo) {
                    widget.onFieldChanged(
                        _fields.updateT(entry.key, (value) => newCustomerInfo));
                  },
                  featureCustomer: entry.key,
                  isLast: isLast,
                  customerInfo: entry.value,
                ),
              );
            }).toList(),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

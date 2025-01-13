import 'package:flutter/material.dart';
import 'package:fms/core/constant/mapper.dart';

import '../../../../general/domain/entities/config_entity.dart';
import '../../../domain/entities/order_entity.dart';
import 'customer_checkbox_group.dart';
import 'customer_radio_group.dart';
import 'customer_text_form_field.dart';

class CustomerField extends StatelessWidget {
  final FeatureCustomer featureCustomer;
  final CustomerInfo customerInfo;
  final bool isLast;
  final Function(CustomerInfo newCustomerInfo) onChanged;
  const CustomerField({
    super.key,
    required this.featureCustomer,
    required this.isLast,
    required this.customerInfo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (featureCustomer.dataType == 'checkbox')
      return CustomerCheckBoxGroup(
          customerInfo: customerInfo,
          onChanged: (value) {
            onChanged(customerInfo.copyWith(options: value));
          },
          featureCustomer: featureCustomer);
    if (featureCustomer.dataType == 'radio')
      return CustomerRadioGroup(
          customerInfo: customerInfo,
          onChanged: (value) {
            onChanged(customerInfo.copyWith(options: value));
          },
          featureCustomer: featureCustomer);

    return AppTextFormField(
      value: customerInfo.value,
      label: featureCustomer.name!,
      isRequired: featureCustomer.isRequired!,
      onChanged: (value) {
        onChanged(customerInfo.copyWith(
            value: featureCustomer.isRequired! ? value.trimLeft() : value));
      },
      textInputType:
          Mapper.dataTypeToInputType(dataType: featureCustomer.dataType!),
      validate: Mapper.dataTypeToValidate(dataType: featureCustomer.dataType!),
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
    );
  }
}

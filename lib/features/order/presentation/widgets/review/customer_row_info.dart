import 'package:flutter/material.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/mixins/extension/context_ext.dart';
import 'package:vnm/core/responsive/responsive.dart';

class CustomerRowInfo extends StatelessWidget {
  final String? label;
  final String? value;
  const CustomerRowInfo({super.key, this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${label} : ',
                  style: context.textTheme.body1
                      ?.copyWith(color: AppColors.nobel)),
              Text(
                value ?? '',
                style:
                    context.textTheme.body1?.copyWith(color: AppColors.black),
              )
            ],
          ),
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fms/core/constant/colors.dart';

class SamplingContainer extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final Widget unit;
  final bool titleFlexible;
  SamplingContainer(
      {super.key,
      required this.trailing,
      required this.unit,
      required this.leading,
      this.titleFlexible = true});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 6,
          child: DefaultTextStyle(
            style: TextStyle(color: AppColors.black),
            child: Row(
              children: [
                Expanded(flex: 6, child: leading),
                Expanded(flex: 2, child: unit),
              ],
            ),
          ),
        ),
        Flexible(flex: 4, child: trailing)
      ],
    ));
  }
}

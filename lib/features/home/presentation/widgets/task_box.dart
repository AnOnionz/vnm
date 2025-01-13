import 'package:flutter/material.dart';
import 'package:fms/core/constant/colors.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/utilities/flex_extention.dart';

class TaskBox extends StatelessWidget {
  final String name;
  final double height;
  final VoidCallback onPressed;

  const TaskBox({
    super.key,
    required this.name,
    required this.onPressed,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.sqr),
                  topRight: Radius.circular(16.sqr),
                  bottomLeft: Radius.circular(16.sqr),
                  bottomRight: Radius.circular(16.sqr))),
          child: Padding(
            padding:
                EdgeInsets.only(top: 10.h, bottom: 10.h, left: 8.h, right: 8.h),
            child: Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: context.textTheme.subtitle1
                    ?.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

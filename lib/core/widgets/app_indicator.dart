import 'package:flutter/widgets.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:rive/rive.dart';

class AppIndicator extends StatelessWidget {
  final double? height;
  final double? width;
  const AppIndicator({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 24.sp,
      width: width ?? 24.sp,
      child: RiveAnimation.asset(
        'loading'.rive.riv,
        fit: BoxFit.contain,
      ),
    );
  }
}

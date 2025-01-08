import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/utilities/flex_extention.dart';
import 'package:vnm/core/widgets/notifications.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/schedule/presentation/services/schedule_service.dart';

class ScheduleBuilder extends StatefulWidget {
  final FeatureEntity feature;
  final bool showBackground;
  final bool isValidateStart;
  final Widget Function(Future<void> Function(Function() function) callback)
      builder;
  const ScheduleBuilder({
    super.key,
    required this.builder,
    required this.feature,
    this.showBackground = true,
    this.isValidateStart = true,
  });

  @override
  State<ScheduleBuilder> createState() => _ScheduleBuilderState();
}

class _ScheduleBuilderState extends State<ScheduleBuilder> {
  final ScheduleService _scheduleService = ScheduleService();

  final Map<FeatureSchedule, bool> currSchedule = {};
  late final List<FeatureSchedule>? schedules = widget.feature.schedules;

  Future<void> validate(VoidCallback callback) async {
    final isValid = await _scheduleService.checkSchedules(schedules);

    if (isValid == true) callback();
    if (isValid == false) {
      if (View.of(context).viewInsets.bottom != 0) {
        FocusManager.instance.primaryFocus?.unfocus();
        await Future.delayed(400.milliseconds);
      }
      showSchedule();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isValidateStart) {
      validate(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showBackground) {
      return widget.builder(validate);
    }
    return Container(
      decoration: BoxDecoration(color: AppColors.white, boxShadow: [
        BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 25,
            color: AppColors.black.withOpacity(0.15))
      ]),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 25.w),
      child: widget.builder(validate),
    );
  }
}

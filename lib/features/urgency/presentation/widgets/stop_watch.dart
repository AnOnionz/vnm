import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vnm/core/constant/colors.dart';

import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatch extends StatefulWidget {
  final DateTime? startAt;

  const StopWatch({super.key, required this.startAt});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  late StopWatchTimer? _stopWatchTimer;

  @override
  void didUpdateWidget(covariant StopWatch oldWidget) {
    super.didUpdateWidget(oldWidget);
    update();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    update();
  }

  void update() {
    if (widget.startAt != null) {
      _stopWatchTimer = StopWatchTimer();
      _stopWatchTimer?.setPresetTime(
          mSec: max(
              DateTime.now().difference(widget.startAt!).inMilliseconds, 0));
      _stopWatchTimer?.onStartTimer();
    } else {
      setState(() {
        _stopWatchTimer = null;
      });
    }
  }

  @override
  void dispose() {
    _stopWatchTimer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<int>(
          stream: _stopWatchTimer?.rawTime,
          initialData: 0,
          builder: (context, snap) {
            final value = snap.data!;
            final displayTime =
                StopWatchTimer.getDisplayTime(value, milliSecond: false);
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                displayTime,
                style: context.textTheme.caption1?.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.w600),
              ),
            );
          },
        ),
      ],
    );
  }
}

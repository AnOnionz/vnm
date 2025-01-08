import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/styles/theme.dart';
import 'package:vnm/core/widgets/app_bar.dart';
import 'package:vnm/core/widgets/notifications.dart';
import 'package:vnm/features/schedule/presentation/services/schedule_service.dart';
import 'package:vnm/features/urgency/domain/entities/urgency_entity.dart';
import 'package:vnm/features/urgency/presentation/cubit/current_urgency_cubit.dart';

import '../../../../core/constant/icons.dart';
import '../../../../core/utilities/overlay.dart';
import '../../../../core/widgets/app_indicator.dart';
import '../../../../core/widgets/data_load_error_widget.dart';
import '../../../../core/widgets/popup.dart';
import '../../../home/domain/entities/general_item_data.dart';
import '../cubit/urgency_cubit.dart';
import '../widgets/urgency_item.dart';

class UrgencyPage extends StatefulWidget {
  final GeneralFeatureData entity;
  const UrgencyPage({super.key, required this.entity});

  @override
  State<UrgencyPage> createState() => _UrgencyPageState();
}

class _UrgencyPageState extends State<UrgencyPage> {
  final ScheduleService _scheduleService = ScheduleService();
  late final _currentUrgencyCubit = Modular.get<CurrentUrgencyCubit>();
  late final _urgencyCubit = Modular.get<UrgencyCubit>();

  UrgencyEntity? _currentUrgency;

  StreamSubscription<UrgencyState>? urgencySubscription;

  @override
  void initState() {
    super.initState();
    OverlayManager.remove(key: 'urgency');
    _currentUrgencyCubit.getCurrentUrgency(widget.entity.feature.id!);
    urgencySubscription = _urgencyCubit.stream.listen((state) {
      if (state is UrgencyLoading) {
        OverlayManager.showLoading();
      }
      if (state is UrgencyBeginFailure) {
        OverlayManager.hideDialog();
        showFailure(
          title: 'Bắt đầu thất bại',
          icon: SvgPicture.asset(AppIcons.failure),
          message: state.failure.message,
          btnText: 'Thử lại',
          onPressed: () async {
            await Future.delayed(
              300.milliseconds,
              () => _urgencyCubit.beginUrgency(
                  featureId: widget.entity.feature.id!,
                  featureUrgencyId: state.featureUrgencyId,
                  note: state.note),
            );
          },
        );
      }
      if (state is UrgencyEndFailure) {
        OverlayManager.hideDialog();
        showFailure(
          title: 'Kết thúc thất bại',
          icon: SvgPicture.asset(AppIcons.failure),
          message: state.failure.message,
          btnText: 'Thử lại',
          onPressed: () async {
            await Future.delayed(
              300.milliseconds,
              () => _urgencyCubit.endUrgency(
                  featureId: widget.entity.feature.id!),
            );
          },
        );
      }
      if (state is UrgencyEnded) {
        OverlayManager.hideDialog();
        setState(() {
          _currentUrgency = null;
        });
      }
      if (state is UrgencyBegan) {
        OverlayManager.hideDialog();
        setState(() {
          _currentUrgency = state.urgency;
        });
      }
    });
    _scheduleService
        .checkSchedules(widget.entity.feature.schedules)
        .then((isValid) {
      if (!isValid) showSchedule();
    });
  }

  @override
  void dispose() {
    urgencySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (_currentUrgency != null) showUrgencyTurnOn();
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          title: widget.entity.feature.name ?? 'Báo cáo khẩn',
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 22.h, bottom: 8.h),
          child: BlocConsumer<CurrentUrgencyCubit, CurrentUrgencyState>(
            bloc: _currentUrgencyCubit,
            listener: (context, state) {
              if (state is CurrentUrgencySuccess) {
                setState(() {
                  _currentUrgency = state.urgency;
                });
              }
            },
            builder: (context, state) {
              if (state is CurrentUrgencySuccess) {
                return ListView.builder(
                  physics: kPhysics,
                  itemCount: widget.entity.feature.featureUrgencies!.length,
                  itemBuilder: (context, index) {
                    final urgency =
                        widget.entity.feature.featureUrgencies![index];
                    return UrgencyItem(
                      feature: widget.entity.feature,
                      featureUrgency: urgency,
                      urgency: _currentUrgency,
                      urgencyCubit: _urgencyCubit,
                    );
                  },
                );
              }
              if (state is CurrentUrgencyFailure) {
                return Center(
                  child: DataLoadErrorWidget(
                      onPressed: () => _currentUrgencyCubit
                          .getCurrentUrgency(widget.entity.feature.id!)),
                );
              }
              return Center(child: AppIndicator());
            },
          ),
        ),
      ),
    );
  }
}

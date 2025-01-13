import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fms/core/constant/icons.dart';
import 'package:fms/core/mixins/fx.dart';
import 'package:fms/core/responsive/responsive.dart';
import 'package:fms/core/widgets/app_bar.dart';
import 'package:fms/core/widgets/popup.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/general/domain/entities/data_entity.dart';
import 'package:fms/features/general/presentation/page/mixin_general.dart';
import 'package:fms/features/schedule/presentation/widgets/schedule_builder.dart';
import 'package:fms/features/sync/presentation/bloc/sync_bloc.dart';
import 'package:fms/features/sync/presentation/bloc/sync_progress_bloc.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/enum.dart';
import '../../../../core/widgets/button/flat.dart';
import '../widgets/expectation_task_listview.dart';

class SyncPage extends StatefulWidget {
  const SyncPage({
    super.key,
  });

  @override
  State<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> with GeneralDataMixin {
  final SyncBloc syncBloc = Modular.get();
  final SyncProgressBloc syncProgressBloc = Modular.get();

  late final feature = general!.config.features!
      .firstWhere((feature) => feature.type == FeatureType.synchronization);

  @override
  void initState() {
    syncBloc.add(SyncStarted());
    super.initState();
  }

  List<FeatureEntity> _expectationSyncTask(
      Map<FeatureEntity, List<BaseEntity>> map) {
    final List<FeatureEntity> features = [];
    map.entries.forEach((element) {
      if (element.value.isNotEmpty) {
        features.add(element.key);
      }
    });
    return features;
  }

  void synchronous() {
    syncProgressBloc.add(SyncProgressStart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: feature.name ?? 'Đồng bộ dữ liệu'),
      body: BlocBuilder<SyncBloc, SyncState>(
        bloc: syncBloc,
        builder: (context, state) {
          final isCompleted = state.status == SyncStatus.synced;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.fromLTRB(16.w, 27.h, 16.w, 0),
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _syncStatus(isCompleted),
                      Flexible(
                          child: ExpectationTaskListView(
                              features: _expectationSyncTask(state.data))),
                      BlocConsumer<SyncProgressBloc, SyncProgressState>(
                        bloc: syncProgressBloc,
                        listener: (context, state) {
                          if (state is SyncProgressFailure) {
                            showFailure(
                              title: 'Đồng bộ thất bại',
                              icon: SvgPicture.asset(AppIcons.failure),
                              message: state.failure.message,
                              btnText: 'Thử lại',
                              onPressed: () async {
                                await Future.delayed(
                                  300.milliseconds,
                                  () =>
                                      syncProgressBloc.add(SyncProgressStart()),
                                );
                              },
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is SyncProgressLoading) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(22.w, 32.h, 22.w, 0),
                              child: LinearProgressIndicator(
                                minHeight: 8.h,
                                backgroundColor: AppColors.nobel,
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16.sqr),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.sqr)),
                ),
              ),
              BlocBuilder<SyncProgressBloc, SyncProgressState>(
                bloc: syncProgressBloc,
                builder: (context, state) {
                  if (state is SyncProgressLoading) {
                    return SizedBox.shrink();
                  }
                  return ScheduleBuilder(
                    feature: feature,
                    builder: (callback) => FlatButton(
                      onPressed:
                          isCompleted ? null : () => callback(synchronous),
                      name: 'Đồng bộ',
                      color: AppColors.primary,
                      disableColor: AppColors.potPourri,
                      disableTextColor: AppColors.delRio,
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget _syncStatus(bool isSynchronized) {
    if (isSynchronized) {
      return FadeIn(
          animate: isSynchronized,
          child: Column(
            children: [
              SvgPicture.asset(
                AppIcons.upload,
                colorFilter: ColorFilter.mode(AppColors.nobel, BlendMode.srcIn),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: Text(
                  'Tất cả dữ liệu đã được đồng bộ',
                  style: context.textTheme.h3,
                ),
              ),
            ],
          ));
    }
    return FadeIn(
      child: Column(
        children: [
          SvgPicture.asset(AppIcons.upload),
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Text(
              'Yêu cầu đồng bộ dữ liệu',
              style: context.textTheme.h3?.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vnm/core/constant/colors.dart';
import 'package:vnm/core/constant/icons.dart';
import 'package:vnm/core/mixins/fx.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/styles/theme.dart';
import 'package:vnm/features/general/presentation/page/mixin_general.dart';
import 'package:vnm/features/home/presentation/widgets/common_feature.dart';
import 'package:vnm/features/home/presentation/widgets/drawer_side.dart';
import 'package:vnm/features/home/presentation/widgets/tasks.dart';
import 'package:vnm/features/profile/mixin_user.dart';
import 'package:vnm/features/urgency/presentation/cubit/current_urgency_cubit.dart';

import '../../../../core/constant/enum.dart';
import '../../../../core/utilities/overlay.dart';
import '../../../../core/widgets/popup.dart';
import '../../../general/presentation/bloc/general_bloc.dart';
import '../bloc/necessary_bloc.dart';
import '../widgets/common_info.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with GeneralDataMixin, UserMixin {
  final NecessaryBloc _necessaryBloc = Modular.get();
  final bloc = Modular.get<GeneralBloc>();
  final _curentUrgencyCubit = Modular.get<CurrentUrgencyCubit>();

  @override
  void initState() {
    super.initState();
    final urgencyId = (general?.config.features ?? [])
        .firstWhereOrNull((feature) => feature.type == FeatureType.urgency)
        ?.id;
    if (urgencyId != null) {
      _curentUrgencyCubit.getCurrentUrgency(urgencyId);
      _curentUrgencyCubit.stream.listen((state) {
        if (state is CurrentUrgencySuccess) {
          if (state.urgency?.id != null) {
            showUrgencyTurnOn();
          }
        }
        ;
      });
    }
  }

  @override
  void dispose() {
    OverlayManager.remove(key: 'urgency');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerSide(),
      drawerScrimColor: AppColors.transparent,
      appBar: PreferredSize(
          preferredSize: Size(context.screenWidth, 35.w),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: AppBar(
              backgroundColor: Colors.amber,
              leading: Align(
                alignment: Alignment.centerLeft,
                child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final packageInfo = snapshot.data!;

                        return Text(
                          '${general?.project.id}-${user!.phone}-${packageInfo.version + '.' + packageInfo.buildNumber}-${kdM.format(general!.createdDate)}-${Platform.operatingSystem}',
                          style: context.textTheme.caption3,
                        );
                      }
                      return SizedBox.shrink();
                    }),
              ),
              forceMaterialTransparency: true,
              leadingWidth: context.screenWidth - 40.w,
              actions: [
                Builder(builder: (context) {
                  return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      child: SvgPicture.asset(AppIcons.circleUser));
                })
              ],
            ),
          )),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15.h),
          child: SingleChildScrollView(
            physics: kPhysics,
            child: Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: BlocProvider(
                create: (context) => _necessaryBloc,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(context, 'Thông tin chung'),
                    Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 40.h),
                        child: CommonInfo(general: general)),
                    _title(context, 'Chức năng hỗ trợ'),
                    Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 40.h),
                        child: CommonFeature()),
                    _title(context, 'Danh sách công việc'),
                    Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
                        child: Tasks()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String name) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w),
      child: Text(
        name,
        style: context.textTheme.h3,
      ),
    );
  }
}

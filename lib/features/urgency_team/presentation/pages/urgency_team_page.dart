import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/responsive/responsive.dart';
import 'package:vnm/core/styles/theme.dart';
import 'package:vnm/core/widgets/app_bar.dart';

import '../../../../core/widgets/app_indicator.dart';
import '../../../../core/widgets/data_load_error_widget.dart';
import '../../../home/domain/entities/general_item_data.dart';
import '../bloc/urgency_team_bloc.dart';
import '../widgets/urgency_team_item.dart';

class UrgencyTeamPage extends StatefulWidget {
  final GeneralFeatureData entity;
  const UrgencyTeamPage({super.key, required this.entity});

  @override
  State<UrgencyTeamPage> createState() => _UrgencyTeamPageState();
}

class _UrgencyTeamPageState extends State<UrgencyTeamPage> {
  late final urgencyTeamBloc = Modular.get<UrgencyTeamBloc>();

  @override
  void initState() {
    urgencyTeamBloc.add(FetchUrgencyTeam(featureId: widget.entity.feature.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
          title: widget.entity.feature.name ?? 'Báo cáo khẩn của team'),
      body: Padding(
        padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
        child: BlocBuilder<UrgencyTeamBloc, UrgencyTeamState>(
          bloc: urgencyTeamBloc,
          builder: (context, state) {
            if (state is UrgencyTeamSuccess) {
              return ListView.separated(
                  physics: kPhysics,
                  itemBuilder: (context, index) =>
                      UrgencyTeamItem(urgency: state.urgencies[index]),
                  separatorBuilder: (context, index) => SizedBox(height: 8.w),
                  itemCount: state.urgencies.length);
            }
            if (state is UrgencyTeamFailure) {
              return Center(
                  child: DataLoadErrorWidget(
                onPressed: () => urgencyTeamBloc.add(
                    FetchUrgencyTeam(featureId: widget.entity.feature.id!)),
              ));
            }
            return Center(child: AppIndicator());
          },
        ),
      ),
    );
  }
}

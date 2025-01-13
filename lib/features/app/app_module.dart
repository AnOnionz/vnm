import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/core/environment/env.dart';
import 'package:fms/core/mixins/common.dart';
import 'package:fms/features/app/presentation/pages/app_page.dart';
import 'package:fms/features/app_information/app_infomation_module.dart';
import 'package:fms/features/attendance/attendance_out_module.dart';
import 'package:fms/features/authentication/authentication_module.dart';
import 'package:fms/features/camera/camera_module.dart';
import 'package:fms/features/crawl/crawl.module.dart';
import 'package:fms/features/generic_data/domain/entities/numeric_sheet_entity.dart';
import 'package:fms/features/generic_data/generic_data_module.dart';
import 'package:fms/features/home/home_module.dart';
import 'package:fms/features/lock/lock_module.dart';
import 'package:fms/features/note/note_module.dart';
import 'package:fms/features/oos/domain/entities/oos_entity.dart';
import 'package:fms/features/oos/oos_module.dart';
import 'package:fms/features/order/history_exchange_module.dart';
import 'package:fms/features/order/lucky_wheel_module.dart';
import 'package:fms/features/order/order_module.dart';
import 'package:fms/features/profile/profile_module.dart';
import 'package:fms/features/report/report_module.dart';
import 'package:fms/features/sampling/sampling_module.dart';
import 'package:fms/features/setting/setting_module.dart';
import 'package:fms/features/sign/sign_module.dart';
import 'package:fms/features/statistic/statistic_module.dart';
import 'package:fms/features/urgency/urgency_module.dart';

import '../../../routes/admin_module.dart';
import '../../../routes/routes.dart';
import '../../core/database/database.dart';
import '../../core/database/local_value.dart';
import '../../core/log/log_entity.dart';
import '../../routes/core_module.dart';
import '../attendance/attendance_in_module.dart';
import '../attendance_report/attendance_report_module.dart';
import '../crawl/domain/entities/crawl_quantity_entity.dart';
import '../general/domain/entities/general_entity.dart';
import '../general/general_module.dart';
import '../leave/leave_module.dart';
import '../note/domain/entities/note_entity.dart';
import '../order/domain/entities/order_entity.dart';
import '../report/domain/entities/photo_entity.dart';
import '../sampling/domain/entities/sampling_entity.dart';
import '../setting/domain/entities/setting_app.dart';
import '../statistic/domain/entities/employee_entity.dart';
import '../statistic/individual_statistic_module.dart';
import '../statistic/individual_statistic_offline_module.dart';
import '../sync/sync_module.dart';
import '../urgency_team/urgency_team_module.dart';
import '../work_place/work_place_module.dart';
import 'presentation/bloc/app_bloc.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
        AuthenticationModule(),
        GeneralModule(),
        SyncModule(),
      ];

  @override
  void binds(i) {
    i.addSingleton(_initializeDatabase);
    i.addSingleton(AppConfig.new);
    i.addLazySingleton(AppBloc.new);
  }

  Future<void> _initializeDatabase() async {
    Fx.log('Initialize database');
    await Database.instance.open([
      LocalValueSchema,
      SettingAppSchema,
      GeneralEntitySchema,
      PhotoEntitySchema,
      NoteEntitySchema,
      CrawlQuantityEntitySchema,
      OrderEntitySchema,
      EmployeeEntitySchema,
      SamplingEntitySchema,
      LogEntitySchema,
      NumericSheetEntitySchema,
      OOSEntitySchema
    ]);
  }

  @override
  void routes(r) {
    r.child(Routes.root,
        child: (_) => const AppPage(), transition: TransitionType.fadeIn);
    r.module(Routes.admin,
        module: AdminModule(), transition: TransitionType.fadeIn);
    r.module(SignModule.route, module: SignModule());
    r.module(WorkPlaceModule.route,
        module: WorkPlaceModule(), transition: TransitionType.fadeIn);
    r.module(HomeModule.route,
        module: HomeModule(), transition: TransitionType.fadeIn);
    r.module(AppInfomationModule.route,
        module: AppInfomationModule(), transition: TransitionType.fadeIn);
    r.module(AttendanceInModule.route,
        module: AttendanceInModule(), transition: TransitionType.fadeIn);
    r.module(AttendanceOutModule.route,
        module: AttendanceOutModule(), transition: TransitionType.fadeIn);
    r.module(AttendanceReportModule.route,
        module: AttendanceReportModule(), transition: TransitionType.fadeIn);
    r.module(CrawlModule.route,
        module: CrawlModule(), transition: TransitionType.fadeIn);
    r.module(LeaveModule.route,
        module: LeaveModule(), transition: TransitionType.fadeIn);
    r.module(NoteModule.route,
        module: NoteModule(), transition: TransitionType.fadeIn);
    r.module(OrderModule.route,
        module: OrderModule(), transition: TransitionType.fadeIn);
    r.module(HistoryExchangeModule.route,
        module: HistoryExchangeModule(), transition: TransitionType.fadeIn);
    r.module(LuckyWheelModule.route,
        module: LuckyWheelModule(), transition: TransitionType.fadeIn);
    r.module(ReportModule.route,
        module: ReportModule(), transition: TransitionType.fadeIn);
    r.module(SettingModule.route,
        module: SettingModule(), transition: TransitionType.fadeIn);
    r.module(SyncModule.route,
        module: SyncModule(), transition: TransitionType.fadeIn);
    r.module(UrgencyModule.route,
        module: UrgencyModule(), transition: TransitionType.fadeIn);
    r.module(UrgencyTeamModule.route,
        module: UrgencyTeamModule(), transition: TransitionType.fadeIn);
    r.module(GenericDataModule.route,
        module: GenericDataModule(), transition: TransitionType.fadeIn);
    r.module(OOSModule.route,
        module: OOSModule(), transition: TransitionType.fadeIn);
    r.module(StatisticModule.route,
        module: StatisticModule(), transition: TransitionType.fadeIn);
    r.module(IndividualStatisticModule.route,
        module: IndividualStatisticModule(), transition: TransitionType.fadeIn);
    r.module(IndividualStatisticOfflineModule.route,
        module: IndividualStatisticOfflineModule(),
        transition: TransitionType.fadeIn);
    r.module(SamplingModule.route,
        module: SamplingModule(), transition: TransitionType.fadeIn);
    r.module(ProfileModule.route,
        module: ProfileModule(), transition: TransitionType.fadeIn);
    r.module(LockModule.route,
        module: LockModule(), transition: TransitionType.fadeIn);
    r.module(CameraModule.route,
        module: CameraModule(), transition: TransitionType.noTransition);
  }
}

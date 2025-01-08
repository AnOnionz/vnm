import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/features/generic_data/generic_data_module.dart';
import 'package:vnm/features/note/note_module.dart';
import 'package:vnm/features/oos/oos_module.dart';
import 'package:vnm/features/order/order_module.dart';
import 'package:vnm/features/report/report_module.dart';
import 'package:vnm/features/sampling/sampling_module.dart';
import 'package:vnm/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:vnm/features/sync/domain/usecases/sync_usecase.dart';
import 'package:vnm/features/sync/presentation/bloc/sync_bloc.dart';
import 'package:vnm/features/sync/presentation/bloc/sync_progress_bloc.dart';
import 'package:vnm/features/sync/presentation/pages/sync_page.dart';

import '../../routes/routes.dart';
import '../crawl/crawl.module.dart';

class SyncModule extends Module {
  static const String route = '/synchronization/';
  @override
  List<Module> get imports => [
        ReportModule(),
        NoteModule(),
        CrawlModule(),
        OrderModule(),
        SamplingModule(),
        GenericDataModule(),
        OOSModule()
      ];

  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton(SyncBloc.new);
    i.addLazySingleton(SyncProgressBloc.new);
  }

  @override
  void binds(Injector i) {
    i.addLazySingleton(SyncRepositoryImpl.new);
    i.addLazySingleton(SyncUseCase.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Routes.root,
      child: (_) => SyncPage(),
    );
  }
}

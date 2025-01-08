import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/features/home/domain/entities/general_item_data.dart';
import 'package:vnm/features/oos/data/datasources/oos_local_datasource.dart';
import 'package:vnm/features/oos/data/datasources/oos_remote_datatsource.dart';
import 'package:vnm/features/oos/data/repositories/oos_repository_impl.dart';
import 'package:vnm/features/oos/domain/usecases/create_oos_usecase.dart';
import 'package:vnm/features/oos/domain/usecases/get_current_oos_usecase.dart';
import 'package:vnm/features/oos/domain/usecases/get_oos_no_synced_usecase.dart';
import 'package:vnm/features/oos/domain/usecases/get_oos_not_completed_usecase.dart';
import 'package:vnm/features/oos/presentation/cubit/fetch_oos_cubit.dart';
import 'package:vnm/features/oos/presentation/cubit/oos_cubit.dart';
import 'package:vnm/features/oos/presentation/pages/oos_page.dart';
import 'package:vnm/routes/routes.dart';

class OOSModule extends Module {
  static const String route = '/outOfStockStatus/';
  @override
  List<Module> get imports => [];
  @override
  void binds(Injector i) {
    i.addLazySingleton(OosRemoteDatatsourceImpl.new);
    i.addLazySingleton(OOSLocalDatasourceImpl.new);
    i.addLazySingleton(OosRepositoryImpl.new);
    i.addLazySingleton(CreateOosUsecase.new);
    i.addLazySingleton(GetCurrentOosUsecase.new);
    i.addLazySingleton(GetOosNoSyncedDataUsecase.new);
    i.addLazySingleton(GetOosNotCompletedUsecase.new);
    i.add(OosCubit.new);
    i.add(FetchOosCubit.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Routes.root,
      child: (_) => OosPage(
        entity: r.args.data as GeneralFeatureData,
      ),
    );
  }
}

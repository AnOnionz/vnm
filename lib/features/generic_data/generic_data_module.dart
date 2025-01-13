import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/features/generic_data/data/datasources/generic_data_remote_datasource.dart';
import 'package:fms/features/generic_data/data/repositories/generic_data_repository_impl.dart';
import 'package:fms/features/generic_data/domain/usecases/create_generic_data_usecase.dart';
import 'package:fms/features/generic_data/domain/usecases/generic_data_no_%20synced_usecase.dart';
import 'package:fms/features/generic_data/domain/usecases/get_generic_data_not_completed_usecase.dart';
import 'package:fms/features/generic_data/domain/usecases/get_generic_data_usecase.dart';
import 'package:fms/features/generic_data/presentation/pages/generic_data_page.dart';
import 'package:fms/routes/routes.dart';

import '../home/domain/entities/general_item_data.dart';
import 'data/datasources/generic_data_local_datasource.dart';
import 'presentation/cubit/generic_data_cubit.dart';

class GenericDataModule extends Module {
  static const String route = '/numericSheet/';
  @override
  List<Module> get imports => [];
  @override
  void binds(Injector i) {
    i.addLazySingleton(GenericDataLocalDatasourceImpl.new);
    i.addLazySingleton(GenericDataRemoteDatasourceImpl.new);
    i.addLazySingleton(GenericDataRepositoryImpl.new);
    i.addLazySingleton(GetGenericDataUsecase.new);
    i.addLazySingleton(CreateGenericDataUsecase.new);
    i.addLazySingleton(GetGenericDataNotCompletedUsecase.new);
    i.addLazySingleton(GetGenericDataNoSyncedDataUsecase.new);
    i.add<GenericDataCubit>(GenericDataCubit.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Routes.root,
      child: (_) => GenericDataPage(
        entity: r.args.data as GeneralFeatureData,
      ),
    );
  }
}

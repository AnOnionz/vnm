import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/features/urgency/data/datasources/urgency_remote_datasource.dart';
import 'package:fms/features/urgency/data/repositories/urgency_repository_impl.dart';
import 'package:fms/features/urgency/domain/usecases/current_urgency_usecase.dart';
import 'package:fms/features/urgency/presentation/cubit/urgency_cubit.dart';

import '../../routes/routes.dart';
import '../home/domain/entities/general_item_data.dart';
import 'domain/usecases/begin_urgency_usecase.dart';
import 'domain/usecases/end_urgency_usecase.dart';
import 'presentation/cubit/current_urgency_cubit.dart';
import 'presentation/pages/urgency_page.dart';

class UrgencyModule extends Module {
  static const String route = '/urgency/';
  @override
  List<Module> get imports => [];

  @override
  void binds(Injector i) {
    i.addLazySingleton(UrgencyRemoteDataSourceImpl.new);
    i.addLazySingleton(UrgencyRepositoryImpl.new);
    i.addLazySingleton(BeginUrgencyUsecase.new);
    i.addLazySingleton(EndUrgencyUsecase.new);
    i.addLazySingleton(CurrentUrgencyUsecase.new);
    i.add(UrgencyCubit.new);
    i.add(CurrentUrgencyCubit.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Routes.root,
      child: (_) => UrgencyPage(entity: r.args.data as GeneralFeatureData),
    );
  }
}

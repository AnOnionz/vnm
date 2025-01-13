import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/features/urgency_team/presentation/pages/urgency_team_page.dart';
import 'package:fms/routes/core_module.dart';
import 'package:fms/routes/routes.dart';

import '../home/domain/entities/general_item_data.dart';
import 'data/datasources/urgency_team_remote_datasource.dart';
import 'data/repositories/urgency_team_repository_impl.dart';
import 'domain/usecases/get_urgency_team_usecase.dart';
import 'presentation/bloc/urgency_team_bloc.dart';

class UrgencyTeamModule extends Module {
  static const String route = '/onlineTeamUrgencyReport/';
  @override
  List<Module> get imports => [CoreModule()];
  @override
  void binds(Injector i) {
    i.addLazySingleton(UrgencyTeamRemoteDataSourceImpl.new);
    i.addLazySingleton(UrgencyTeamRepositoryImpl.new);
    i.add(GetUrgencyTeamUsecase.new);
    i.add(UrgencyTeamBloc.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      Routes.root,
      child: (_) => UrgencyTeamPage(entity: r.args.data as GeneralFeatureData),
    );
  }
}

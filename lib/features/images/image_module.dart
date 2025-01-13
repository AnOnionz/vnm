import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/features/images/data/datasource/delete_image_remote_datasource.dart';
import 'package:fms/features/images/presentation/bloc/delete_image_bloc.dart';

import 'package:fms/routes/core_module.dart';

import 'data/datasource/delete_image_local_remote_datasource.dart';

class ImageModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  @override
  void binds(Injector i) {
    i.addLazySingleton(DeletePhotoRemoteDataSource.new);
    i.addLazySingleton(DeletePhotoLocalDataSource.new);
    i.add<DeleteImageBloc>(DeleteImageBloc.new);
  }
}

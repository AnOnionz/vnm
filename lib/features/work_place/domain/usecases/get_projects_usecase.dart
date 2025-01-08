import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/work_place/domain/entities/project_entity.dart';

import '../../data/repositories/work_place_repository_impl.dart';

class GetProjectsUsecase extends UseCase<List<ProjectEntity>, void> {
  final WorkPlaceRepositoryImpl _appRepositoryImpl;

  GetProjectsUsecase(this._appRepositoryImpl);
  @override
  Future<Result<List<ProjectEntity>>> call([void params]) async {
    return _appRepositoryImpl.getProjects();
  }
}

import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/mixins/extension/func_ext.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/data/repository/general_repository_impl.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/work_place/domain/entities/work_place_entity.dart';

class GetConfigUsecase extends UseCase<ConfigEntity?, WorkPlaceEntity> {
  final GeneralRepository _repository;

  GetConfigUsecase(this._repository);
  @override
  Future<Result<ConfigEntity?>> call(WorkPlaceEntity params) async {
    return _repository.getRemoteConfig(params).withLoading();
  }
}

import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/mixins/extension/func_ext.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/oos/data/repositories/oos_repository_impl.dart';

import '../entities/oos_entity.dart';

class CreateOosUsecase extends UseCase<OOSEntity?, CreateOosParams> {
  final OosRepositoryImpl _repository;

  CreateOosUsecase(this._repository);
  @override
  Future<Result<OOSEntity?>> call(CreateOosParams params) async {
    return _repository
        .createOOS(entity: params.entity, feature: params.feature)
        .withLoading();
  }
}

class CreateOosParams extends Params {
  final OOSEntity entity;
  final FeatureEntity feature;

  CreateOosParams({required this.entity, required this.feature});
}

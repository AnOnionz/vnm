import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/oos/data/repositories/oos_repository_impl.dart';
import 'package:fms/features/oos/domain/entities/oos_entity.dart';

class GetCurrentOosUsecase extends UseCase<OOSEntity?, FeatureEntity> {
  final OosRepositoryImpl _repository;

  GetCurrentOosUsecase(this._repository);
  @override
  Future<Result<OOSEntity?>> call(FeatureEntity params) async {
    return _repository.getCurrentOOS(feature: params);
  }
}

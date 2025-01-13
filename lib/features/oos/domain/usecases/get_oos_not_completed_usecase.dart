import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/oos/data/repositories/oos_repository_impl.dart';

class GetOosNotCompletedUsecase extends UseCase<FeatureEntity?, FeatureEntity> {
  final OosRepositoryImpl _repository;

  GetOosNotCompletedUsecase(this._repository);
  @override
  Future<Result<FeatureEntity?>> call(FeatureEntity params) async {
    return await _repository.getOOSNotCompleted(feature: params);
  }
}

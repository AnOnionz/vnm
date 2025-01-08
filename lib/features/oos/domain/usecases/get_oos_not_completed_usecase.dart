import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/oos/data/repositories/oos_repository_impl.dart';

class GetOosNotCompletedUsecase extends UseCase<FeatureEntity?, FeatureEntity> {
  final OosRepositoryImpl _repository;

  GetOosNotCompletedUsecase(this._repository);
  @override
  Future<Result<FeatureEntity?>> call(FeatureEntity params) async {
    return await _repository.getOOSNotCompleted(feature: params);
  }
}

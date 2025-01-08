import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/generic_data/data/repositories/generic_data_repository_impl.dart';

class GetGenericDataNotCompletedUsecase
    extends UseCase<FeatureEntity?, FeatureEntity> {
  GetGenericDataNotCompletedUsecase(this._repository);

  final GenericDataRepositoryImpl _repository;
  @override
  Future<Result<FeatureEntity?>> call(FeatureEntity params) {
    return _repository.getNumericDataNotCompleted(feature: params);
  }
}

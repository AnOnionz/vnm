import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/generic_data/data/repositories/generic_data_repository_impl.dart';

class GetGenericDataNotCompletedUsecase
    extends UseCase<FeatureEntity?, FeatureEntity> {
  GetGenericDataNotCompletedUsecase(this._repository);

  final GenericDataRepositoryImpl _repository;
  @override
  Future<Result<FeatureEntity?>> call(FeatureEntity params) {
    return _repository.getNumericDataNotCompleted(feature: params);
  }
}

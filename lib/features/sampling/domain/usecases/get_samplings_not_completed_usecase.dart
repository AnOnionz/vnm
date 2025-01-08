import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/sampling/data/repositories/sampling_repository_impl.dart';

class GetSamplingsNotCompletedUsecase
    extends UseCase<FeatureEntity?, FeatureEntity> {
  final SamplingRepositoryImpl repository;

  GetSamplingsNotCompletedUsecase(this.repository);
  @override
  Future<Result<FeatureEntity?>> call(FeatureEntity params) {
    return repository.getSamplingNotCompleted(feature: params);
  }
}

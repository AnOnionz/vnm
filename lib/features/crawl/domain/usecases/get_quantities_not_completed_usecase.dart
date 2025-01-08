import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/crawl/data/repositories/crawl_repository_impl.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';

class GetQuantitiesNotCompletedUsecase
    extends UseCase<FeatureEntity?, FeatureEntity> {
  final CrawlRepositoryImpl repository;

  GetQuantitiesNotCompletedUsecase(this.repository);
  @override
  Future<Result<FeatureEntity?>> call(FeatureEntity params) {
    return repository.getQuantitiesNotCompleted(feature: params);
  }
}

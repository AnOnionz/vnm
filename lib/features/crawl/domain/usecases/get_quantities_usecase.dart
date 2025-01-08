import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/crawl/data/repositories/crawl_repository_impl.dart';
import 'package:vnm/features/crawl/domain/entities/crawl_quantity_entity.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';

class GetQuantitiesUsecase
    extends UseCase<CrawlQuantityEntity?, FeatureEntity> {
  final CrawlRepositoryImpl repository;

  GetQuantitiesUsecase(this.repository);
  @override
  Future<Result<CrawlQuantityEntity?>> call(FeatureEntity params) {
    return repository.getQuantities(feature: params);
  }
}

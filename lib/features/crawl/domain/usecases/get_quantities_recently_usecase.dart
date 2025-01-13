import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/crawl/domain/entities/recently_quantity_entity.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';

import '../../../../core/constant/type_def.dart';
import '../../data/repositories/crawl_repository_impl.dart';

class GetQuantitiesRecentlyUsecase
    extends UseCase<List<RecentlyQuantityEntity>, FeatureEntity> {
  final CrawlRepositoryImpl repository;

  GetQuantitiesRecentlyUsecase(this.repository);
  @override
  Future<Result<List<RecentlyQuantityEntity>>> call(FeatureEntity params) {
    return repository.getQuantitiesRecently(feature: params);
  }
}

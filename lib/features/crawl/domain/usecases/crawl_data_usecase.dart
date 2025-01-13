import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/mixins/extension/func_ext.dart';
import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/crawl/domain/entities/crawl_quantity_entity.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';

import '../../data/repositories/crawl_repository_impl.dart';

class CrawlDataUsecase extends UseCase<CrawlQuantityEntity, QuantitiesParams> {
  final CrawlRepositoryImpl repository;

  CrawlDataUsecase(this.repository);
  @override
  Future<Result<CrawlQuantityEntity>> call(QuantitiesParams params) async {
    return repository
        .crawlQuantities(feature: params.feature, quantities: params.quantities)
        .withLoading();
  }
}

class QuantitiesParams {
  final CrawlQuantityEntity quantities;
  final FeatureEntity feature;

  QuantitiesParams({required this.quantities, required this.feature});
}

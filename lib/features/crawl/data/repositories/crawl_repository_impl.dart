import 'package:collection/collection.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/core/constant/enum.dart';
import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/repository/repository.dart';
import 'package:fms/features/crawl/data/datasources/crawl_local_datasource.dart';
import 'package:fms/features/crawl/domain/entities/crawl_quantity_entity.dart';
import 'package:fms/features/crawl/domain/entities/recently_quantity_entity.dart';
import 'package:fms/features/crawl/domain/repositories/crawl_repository.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/general/presentation/page/mixin_general.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/network_time/network_time_service.dart';
import '../../../../core/usecase/either.dart';
import '../datasources/crawl_remote_datasource.dart';

class CrawlRepositoryImpl extends Repository
    with GeneralDataMixin
    implements CrawlRepository {
  final CrawlLocalDatasource _local;
  final CrawlRemoteDatasource _remote;

  CrawlRepositoryImpl(this._local, this._remote);

  final networkTimeService = Modular.get<NetworkTimeService>();

  @override
  Future<Result<CrawlQuantityEntity>> crawlQuantities({
    required CrawlQuantityEntity quantities,
    required FeatureEntity feature,
  }) {
    return todo(
      () async {
        final time = await Modular.get<NetworkTimeService>().ntpDateTime();
        quantities = quantities.copyWith(
            dataTimestamp: time,
            dataUuid: Uuid().v1(),
            featureId: feature.id,
            attendanceId: general!.attendance?.id);
        final response = await _remote.createQuantities(
            quantities: quantities, general: general!);
        if (response != null) {
          quantities =
              quantities.copyWith(id: response.id, status: SyncStatus.synced);
        }
        _local.cacheQuantitiesToLocal(quantities);
        return Right(quantities);
      },
      onFailure: (failure) {
        _local.cacheQuantitiesToLocal(quantities);
      },
    );
  }

  @override
  Future<Result<CrawlQuantityEntity?>> getQuantities(
      {required FeatureEntity feature}) async {
    return todo(() async {
      final localCrawlQuantities = await _local.getQuantitiesByFeature(feature);
      if (localCrawlQuantities.isNotEmpty) {
        return Right(localCrawlQuantities.last);
      }
      final crawlQuantities =
          await _remote.getQuantities(general: general!, feature: feature);

      if (crawlQuantities != null) {
        return Right(crawlQuantities);
      }
      final CrawlQuantityEntity entity = CrawlQuantityEntity(
        dataUuid: Uuid().v1(),
        dataTimestamp: await networkTimeService.ntpDateTime(),
        attendanceId: general!.attendance!.id,
        featureId: feature.id,
        values: [],
      );
      List<CrawlQuantitylValueEntity> values = [];
      if (feature.isAutofill == true) {
        final crawlQuantities = await _remote.getQuantitiesRecently(
            general: general!, feature: feature);

        if (crawlQuantities.isEmpty) return Right(null);

        values = (feature.featureQuantities ?? [])
            .map((FeatureQuantity featureQuantity) {
          final value = crawlQuantities
              .firstWhereOrNull((element) =>
                  (element.featureQuantity.item != null &&
                      featureQuantity.item != null &&
                      element.featureQuantity.item?.id ==
                          featureQuantity.item?.id) ||
                  (element.featureQuantity.product?.id ==
                          featureQuantity.product?.id &&
                      element.featureQuantity.productPackaging?.id ==
                          featureQuantity.productPackaging?.id))
              ?.value;
          return CrawlQuantitylValueEntity(
            featureQuantityId: featureQuantity.id!,
            value: value,
          );
        }).toList();
      }
      if (values.isEmpty) return Right(null);
      return Right(entity.copyWith(values: values));
    });
  }

  @override
  Future<Result<List<RecentlyQuantityEntity>>> getQuantitiesRecently(
      {required FeatureEntity feature}) async {
    return todo(() async {
      final crawlQuantities = await _remote.getQuantitiesRecently(
          general: general!, feature: feature);
      return Right(crawlQuantities);
    }, useInternet: true);
  }

  @override
  Future<Result<FeatureEntity?>> getQuantitiesNotCompleted(
      {required FeatureEntity feature}) async {
    return todo(() async {
      final quantities = await _local.getQuantitiesByFeature(feature);
      if (quantities.isEmpty) {
        return Right(feature);
      } else {
        return Right(null);
      }
    });
  }

  @override
  Future<Result<Map<int, List<CrawlQuantityEntity>>>> noSyncedData() async {
    return todo(() async {
      final localPhotos = await _local.getQuantities();
      final map = localPhotos.groupListsBy((element) => element.featureId!);
      map.entries.forEach(
        (element) {
          element.value
              .removeWhere((element) => element.status == SyncStatus.synced);
        },
      );

      return Right(map);
    });
  }

  @override
  Future<void> synchronized(FeatureEntity feature) async {
    final quantitiesNoSynced = await _local.getQuantitiessNoSynced(feature);
    return await Future.forEach(quantitiesNoSynced, (quantities) async {
      final response = await _remote.createQuantities(
          quantities: quantities, general: general!);
      if (response != null) {
        quantities =
            quantities.copyWith(id: response.id, status: SyncStatus.synced);
        _local.cacheQuantitiesToLocal(quantities);
      }
    });
  }
}

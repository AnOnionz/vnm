import 'package:collection/collection.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/core/constant/enum.dart';
import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/errors/failure.dart';
import 'package:fms/core/repository/repository.dart';
import 'package:fms/core/services/network_time/network_time_service.dart';
import 'package:fms/core/usecase/either.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/general/presentation/page/mixin_general.dart';
import 'package:fms/features/oos/data/datasources/oos_local_datasource.dart';
import 'package:fms/features/oos/data/datasources/oos_remote_datatsource.dart';
import 'package:fms/features/oos/domain/entities/oos_entity.dart';
import 'package:fms/features/oos/domain/repositories/oos_repository.dart';
import 'package:uuid/uuid.dart';

class OosRepositoryImpl extends Repository
    with GeneralDataMixin
    implements OosRepository {
  final OOSLocalDatasourceImpl local;
  final OosRemoteDatatsourceImpl remote;

  OosRepositoryImpl(this.local, this.remote);
  @override
  Future<Result<OOSEntity?>> createOOS(
      {required OOSEntity entity, required FeatureEntity feature}) async {
    return todo(() async {
      final time = await Modular.get<NetworkTimeService>().ntpDateTime();
      entity = entity.copyWith(
        dataTimestamp: time,
        dataUuid: Uuid().v1(),
        featureId: feature.id,
        attendanceId: general!.attendance?.id,
      );

      final oos = await remote.createOOS(model: entity.toModel());
      if (oos != null) {
        entity = entity.copyWith(id: oos.id, status: SyncStatus.synced);
        local.cacheOOSToLocal(entity);
        return Right(entity.copyWith());
      }
      return Left(DataNullFailure());
    }, useInternet: true);
  }

  @override
  Future<Result<OOSEntity?>> getCurrentOOS(
      {required FeatureEntity feature}) async {
    return todo(() async {
      final localGenericData = await local.getOOSByFeature(feature);
      if (localGenericData.isNotEmpty) {
        return Right(localGenericData.last.copyWith());
      }
      final remoteOOS = await remote.getCurrentOOS(
          attendanceId: general!.attendance!.id!, featureId: feature.id!);
      return Right(remoteOOS);
    });
  }

  @override
  Future<Result<FeatureEntity?>> getOOSNotCompleted(
      {required FeatureEntity feature}) async {
    return todo(() async {
      final oos = await local.getOOSByFeature(feature);
      if (oos.isEmpty) {
        return Right(feature);
      } else {
        return Right(null);
      }
    });
  }

  @override
  Future<Result<Map<int, List<OOSEntity>>>> noSyncedData() async {
    return todo(() async {
      final localData = await local.getOOS();

      final map = localData.groupListsBy((element) => element.featureId!);
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
    final dataNoSynced = await local.getOOSByFeature(feature);

    return await Future.forEach(dataNoSynced, (oos) async {
      final response = await remote.createOOS(model: oos.toModel());
      if (response != null) {
        oos = oos.copyWith(id: response.id, status: SyncStatus.synced);
        local.cacheOOSToLocal(oos);
      }
    });
  }
}

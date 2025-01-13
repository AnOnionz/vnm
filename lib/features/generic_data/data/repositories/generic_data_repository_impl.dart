import 'package:collection/collection.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fms/core/constant/enum.dart';
import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/repository/repository.dart';
import 'package:fms/core/services/network_time/network_time_service.dart';
import 'package:fms/core/usecase/either.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/general/presentation/page/mixin_general.dart';
import 'package:fms/features/generic_data/data/datasources/generic_data_local_datasource.dart';
import 'package:fms/features/generic_data/data/datasources/generic_data_remote_datasource.dart';
import 'package:fms/features/generic_data/domain/entities/numeric_sheet_entity.dart';
import 'package:fms/features/generic_data/domain/repositories/generic_data_repository.dart';
import 'package:uuid/uuid.dart';

class GenericDataRepositoryImpl extends Repository
    with GeneralDataMixin
    implements GenericDataRepository {
  GenericDataRepositoryImpl(this._local, this._remote);

  final GenericDataLocalDatasourceImpl _local;
  final GenericDataRemoteDatasourceImpl _remote;

  @override
  Future<Result<NumericSheetEntity?>> createGenericData(
      {required NumericSheetEntity entity,
      required FeatureEntity feature}) async {
    return todo(
      () async {
        final time = await Modular.get<NetworkTimeService>().ntpDateTime();
        entity = entity.copyWith(
          dataTimestamp: time,
          dataUuid: Uuid().v1(),
          featureId: feature.id,
          attendanceId: general!.attendance?.id,
        );

        final response = await _remote.createGenericData(
          model: entity,
        );
        if (response != null) {
          entity = entity.copyWith(id: response.id, status: SyncStatus.synced);
        }
        _local.cacheGenericDataToLocal(entity);
        return Right(entity);
      },
      onFailure: (failure) {
        _local.cacheGenericDataToLocal(entity);
      },
    );
  }

  @override
  Future<Result<NumericSheetEntity?>> getGenericData(
      {required FeatureEntity feature}) async {
    return todo(() async {
      final localGenericData = await _local.getGenericDataByFeature(feature);
      if (localGenericData.isNotEmpty) {
        return Right(localGenericData.last.copyWith());
      }
      final genericData = await _remote.getGenericData(
          attendanceId: general!.attendance!.id!, featureId: feature.id!);
      return Right(genericData);
    });
  }

  @override
  Future<Result<FeatureEntity?>> getNumericDataNotCompleted(
      {required FeatureEntity feature}) async {
    return todo(() async {
      final numerics = await _local.getGenericDataByFeature(feature);
      if (numerics.isEmpty) {
        return Right(feature);
      } else {
        return Right(null);
      }
    });
  }

  @override
  Future<Result<Map<int, List<NumericSheetEntity>>>> noSyncedData() async {
    return todo(() async {
      final localData = await _local.getGenericData();

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
    final dataNoSynced = await _local.getGenericDataByFeature(feature);

    return await Future.forEach(dataNoSynced, (numericSheet) async {
      final response = await _remote.createGenericData(model: numericSheet);
      if (response != null) {
        numericSheet =
            numericSheet.copyWith(id: response.id, status: SyncStatus.synced);
        _local.cacheGenericDataToLocal(numericSheet);
      }
    });
  }
}

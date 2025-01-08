import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/data_source/local_data_source.dart';
import 'package:vnm/core/services/network_time/network_time_service.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/general/presentation/page/mixin_general.dart';
import 'package:vnm/features/generic_data/domain/entities/numeric_sheet_entity.dart';
import 'package:isar/isar.dart';

abstract class GenericDataLocalDatasource {
  void cacheGenericDataToLocal(NumericSheetEntity entity);
  Future<List<NumericSheetEntity>> getGenericData();
  Future<List<NumericSheetEntity>> getGenericDataByFeature(
      FeatureEntity feature);
  Future<List<NumericSheetEntity>> getGenericDatasNoSynced(
      FeatureEntity feature);
}

class GenericDataLocalDatasourceImpl
    with LocalDatasource, GeneralDataMixin
    implements GenericDataLocalDatasource {
  @override
  void cacheGenericDataToLocal(NumericSheetEntity entity) {
    db.addObject<NumericSheetEntity>(entity);
  }

  @override
  Future<List<NumericSheetEntity>> getGenericData() async {
    if (general == null || general!.attendance == null) return [];
    final time = await Modular.get<NetworkTimeService>().betweenToday();
    return db.filter<NumericSheetEntity>((filter) => filter
        .attendanceIdEqualTo(general!.attendance?.id)
        .dataTimestampBetween(time.yesterday, time.today)
        .build());
  }

  @override
  Future<List<NumericSheetEntity>> getGenericDataByFeature(
      FeatureEntity feature) async {
    final time = await Modular.get<NetworkTimeService>().betweenToday();
    return db.filter<NumericSheetEntity>((filter) => filter
        .attendanceIdEqualTo(general!.attendance?.id)
        .featureIdEqualTo(feature.id)
        .dataTimestampBetween(time.yesterday, time.today)
        .build());
  }

  @override
  Future<List<NumericSheetEntity>> getGenericDatasNoSynced(
      FeatureEntity feature) async {
    final time = await Modular.get<NetworkTimeService>().betweenToday();
    return db.filter<NumericSheetEntity>((filter) => filter
        .attendanceIdEqualTo(general!.attendance?.id)
        .featureIdEqualTo(feature.id)
        .dataTimestampBetween(time.yesterday, time.today)
        .statusEqualTo(SyncStatus.isNoSynced)
        .build());
  }
}

import 'package:flutter_modular/flutter_modular.dart';
import 'package:vnm/core/constant/enum.dart';
import 'package:vnm/core/data_source/local_data_source.dart';
import 'package:vnm/core/services/network_time/network_time_service.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/general/presentation/page/mixin_general.dart';
import 'package:vnm/features/oos/domain/entities/oos_entity.dart';
import 'package:isar/isar.dart';

abstract class OOSLocalDatasource {
  void cacheOOSToLocal(OOSEntity model);
  Future<List<OOSEntity>> getOOS();
  Future<List<OOSEntity>> getOOSByFeature(FeatureEntity feature);
  Future<List<OOSEntity>> getOOSNoSynced(FeatureEntity feature);
}

class OOSLocalDatasourceImpl
    with LocalDatasource, GeneralDataMixin
    implements OOSLocalDatasource {
  @override
  void cacheOOSToLocal(OOSEntity model) {
    db.addObject<OOSEntity>(model);
  }

  @override
  Future<List<OOSEntity>> getOOS() async {
    if (general == null || general!.attendance == null) return [];
    final time = await Modular.get<NetworkTimeService>().betweenToday();
    return db.filter<OOSEntity>((filter) => filter
        .attendanceIdEqualTo(general!.attendance?.id)
        .dataTimestampBetween(time.yesterday, time.today)
        .build());
  }

  @override
  Future<List<OOSEntity>> getOOSByFeature(FeatureEntity feature) async {
    final time = await Modular.get<NetworkTimeService>().betweenToday();
    return db.filter<OOSEntity>((filter) => filter
        .attendanceIdEqualTo(general!.attendance?.id)
        .featureIdEqualTo(feature.id)
        .dataTimestampBetween(time.yesterday, time.today)
        .build());
  }

  @override
  Future<List<OOSEntity>> getOOSNoSynced(FeatureEntity feature) async {
    final time = await Modular.get<NetworkTimeService>().betweenToday();
    return db.filter<OOSEntity>((filter) => filter
        .attendanceIdEqualTo(general!.attendance?.id)
        .featureIdEqualTo(feature.id)
        .dataTimestampBetween(time.yesterday, time.today)
        .statusEqualTo(SyncStatus.isNoSynced)
        .build());
  }
}

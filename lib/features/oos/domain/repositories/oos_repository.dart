import 'package:fms/core/constant/type_def.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/oos/domain/entities/oos_entity.dart';

abstract class OosRepository {
  Future<Result<OOSEntity?>> getCurrentOOS({required FeatureEntity feature});
  Future<Result<OOSEntity?>> createOOS(
      {required OOSEntity entity, required FeatureEntity feature});
  Future<Result<FeatureEntity?>> getOOSNotCompleted(
      {required FeatureEntity feature});
  Future<Result<Map<int, List<OOSEntity>>>> noSyncedData();
  Future<void> synchronized(FeatureEntity feature);
}

import 'package:fms/core/constant/type_def.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/generic_data/domain/entities/numeric_sheet_entity.dart';

abstract class GenericDataRepository {
  Future<Result<NumericSheetEntity?>> createGenericData(
      {required NumericSheetEntity entity, required FeatureEntity feature});
  Future<Result<NumericSheetEntity?>> getGenericData(
      {required FeatureEntity feature});
  Future<Result<FeatureEntity?>> getNumericDataNotCompleted(
      {required FeatureEntity feature});
  Future<Result<Map<int, List<NumericSheetEntity>>>> noSyncedData();
  Future<void> synchronized(FeatureEntity feature);
}

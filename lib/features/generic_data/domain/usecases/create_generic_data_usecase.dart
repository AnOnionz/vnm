import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/mixins/extension/func_ext.dart';
import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/generic_data/data/repositories/generic_data_repository_impl.dart';
import 'package:fms/features/generic_data/domain/entities/numeric_sheet_entity.dart';

class CreateGenericDataUsecase
    extends UseCase<NumericSheetEntity?, CreateGenericDataParams> {
  CreateGenericDataUsecase(this._repository);
  final GenericDataRepositoryImpl _repository;

  @override
  Future<Result<NumericSheetEntity?>> call(
      CreateGenericDataParams params) async {
    return _repository
        .createGenericData(entity: params.entity, feature: params.feature)
        .withLoading();
  }
}

class CreateGenericDataParams extends Params {
  final FeatureEntity feature;
  final NumericSheetEntity entity;

  CreateGenericDataParams({required this.feature, required this.entity});
}

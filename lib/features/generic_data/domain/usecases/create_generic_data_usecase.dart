import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/mixins/extension/func_ext.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/generic_data/data/repositories/generic_data_repository_impl.dart';
import 'package:vnm/features/generic_data/domain/entities/numeric_sheet_entity.dart';

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

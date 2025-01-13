import 'package:fms/core/constant/type_def.dart';
import 'package:fms/core/usecase/usecase.dart';
import 'package:fms/features/general/domain/entities/config_entity.dart';
import 'package:fms/features/generic_data/data/repositories/generic_data_repository_impl.dart';
import 'package:fms/features/generic_data/domain/entities/numeric_sheet_entity.dart';

class GetGenericDataUsecase
    extends UseCase<NumericSheetEntity?, FeatureEntity> {
  GetGenericDataUsecase(this._repository);
  final GenericDataRepositoryImpl _repository;

  @override
  Future<Result<NumericSheetEntity?>> call(FeatureEntity params) async {
    return await _repository.getGenericData(feature: params);
  }
}

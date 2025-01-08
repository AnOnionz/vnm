import 'package:vnm/core/constant/type_def.dart';
import 'package:vnm/core/usecase/usecase.dart';
import 'package:vnm/features/general/domain/entities/config_entity.dart';
import 'package:vnm/features/generic_data/data/repositories/generic_data_repository_impl.dart';
import 'package:vnm/features/generic_data/domain/entities/numeric_sheet_entity.dart';

class GetGenericDataUsecase
    extends UseCase<NumericSheetEntity?, FeatureEntity> {
  GetGenericDataUsecase(this._repository);
  final GenericDataRepositoryImpl _repository;

  @override
  Future<Result<NumericSheetEntity?>> call(FeatureEntity params) async {
    return await _repository.getGenericData(feature: params);
  }
}
